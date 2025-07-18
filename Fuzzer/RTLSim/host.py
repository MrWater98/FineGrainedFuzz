import sys
import cocotb

from cocotb.decorators import coroutine
from cocotb.triggers import Timer, RisingEdge
from reader.tile_reader import tileSrcReader
from adapters.tile_adapter import tileAdapter

SUCCESS = 0
ASSERTION_FAIL = 1
TIME_OUT = 2
ILL_MEM = -1

DRAM_BASE = 0x80000000

class rtlInput():
    def __init__(self, hexfile, intrfile, data, symbols, max_cycles):
        self.hexfile = hexfile
        self.intrfile = intrfile
        self.data = data
        self.symbols = symbols
        self.max_cycles = max_cycles

class rvRTLhost():
    def __init__(self, dut, toplevel, rtl_sig_file, debug=False):
        source_info = 'infos/' + toplevel + '_info.txt'
        reader = tileSrcReader(source_info)

        paths = reader.return_map()

        port_names = paths['port_names']
        monitor_pc = paths['monitor_pc']
        monitor_valid = paths['monitor_valid']
        # wb_reg_pc: 在写回阶段，wb_reg_pc 保存了当前正在写回的指令的地址。这对于调试和错误处理非常有用，因为你可以追踪到具体是哪条指令引发了异常或错误。
        # wb_reg_valid: 在写回阶段，wb_reg_valid 信号指示当前写回的结果是否有效。如果某条指令在执行过程中被取消或发生了异常，
        # wb_reg_valid 可能会被设置为无效（例如，低电平），以防止错误的数据被写回寄存器文件或内存。
        monitor = (monitor_pc[0], monitor_valid[0])

        self.rtl_sig_file = rtl_sig_file
        self.debug = debug

        self.dut = dut
        self.adapter = tileAdapter(dut, port_names, monitor, self.debug)

    def debug_print(self, message):
        if self.debug:
            print(message)

    def set_bootrom(self):
        bootrom_addrs = []
        memory = {}
        bootrom = [ 0x00000297, # auipc t0, 0x0
                    0x02028593, # addi a1, t0, 32
                    0xf1402573, # csrr a0, mhartid
                    0x0182b283, # ld t0, 24(t0)
                    0x00028067, # jr t0
                    0x00000000, # no data
                    0x80000000, # Jump address
                    0x00000000,
                    0x00000000,
                    0x00000000,
                    0x00000000,
                    0x00000000,
                    0x00000000,
                    0x00000000,
                    0x00000000,
                    0x00000000 ] # no data

        for i in range(0, len(bootrom), 2):
            bootrom_addrs.append(0x10000 + i * 4)
            memory[0x10000 + i * 4] = (bootrom[i+1] << 32) | bootrom[i]

        return (bootrom_addrs, memory)

    @coroutine
    def clock_gen(self, clock, period=2):
        while True:
            clock <= 1
            yield Timer(period / 2)
            clock <= 0
            yield Timer(period / 2)



    @coroutine
    def reset(self, clock, metaReset, reset, timer=5):
        clkedge = RisingEdge(clock)

        metaReset <= 1
        for i in range(timer):
            yield clkedge
        metaReset <= 0
        reset <= 1
        for i in range(timer):
            yield clkedge
        reset <= 0

    def save_signature(self, memory, sig_start, sig_end, data_addrs, sig_file):
        fd = open(sig_file, 'w')
        for i in range(sig_start, sig_end, 16):
            dump = '{:016x}{:016x}\n'.format(memory[i+8], memory[i])
            fd.write(dump)

        for (data_start, data_end) in data_addrs:
            for i in range(data_start, data_end, 16):
                dump = '{:016x}{:016x}\n'.format(memory[i+8], memory[i])
                fd.write(dump)

        fd.close()

    def get_covsum(self):
        cov_mask = (1 << len(self.dut.io_covSum)) - 1
        return self.dut.io_covSum.value & cov_mask

    def get_path(self):
        # Iterate all coverages with coverage{i}
        path_list = []
        for i in range(0,200):
            # if getattr(dut, "coverage{i}") is exist
            if hasattr(self.dut, "coverage{}".format(i)):
                visit_path = getattr(self.dut, "coverage{}".format(i)).value
                for j in range(0, len(visit_path)):
                    if visit_path[j]==1:
                        path_list.append((i,j))
            else:
                break
        return path_list
    
    @coroutine
    def run_test(self, rtl_input: rtlInput, assert_intr: bool, iteration):

        self.debug_print('[RTLHost] Start RTL simulation')

        fd = open(rtl_input.hexfile, 'r')
        lines = fd.readlines()
        fd.close()

        max_cycles = rtl_input.max_cycles

        symbols = rtl_input.symbols
        _start = symbols['_start']
        _end = symbols['_end_main']

        (bootrom_addrs, memory) = self.set_bootrom()
        for (i, addr) in enumerate(range(_start, _end + 36, 8)):
            memory[addr] = int(lines[i], 16)

        '''
        tohost 是一个特殊地址，用于与仿真器或测试环境进行通信。在 RISC-V 的测试和仿真环境中，典型的用法如下：
        报告测试结果: 将特定值写入 tohost 地址，以通知测试环境测试的状态（通过、失败等）。
        中断模拟: 在某些仿真环境中，写入 tohost 可以触发仿真器执行某些操作，如停止仿真或者生成中断。
        在上述代码中，将 1 写入 tohost 可能表示测试结束或成功。
        '''
        tohost_addr = symbols['tohost']
        sig_start = symbols['begin_signature']
        sig_end = symbols['end_signature']

        memory[tohost_addr] = 0
        for addr in range(sig_start // 8 * 8, sig_end, 8):
            memory[addr] = 0

        data = rtl_input.data
        data_addrs = []
        offset = 0
        for n in range(6):
            data_start = symbols['_random_data{}'.format(n)]
            data_end = symbols['_end_data{}'.format(n)]
            data_addrs.append((data_start, data_end))

            for i, addr in enumerate(range(data_start // 8 * 8, data_end // 8 * 8, 8)):
                word = data[i + offset]
                memory[addr] = word

            offset += (data_end - data_start) // 8

        ints = {}
        if assert_intr:
            fd = open(rtl_input.intrfile, 'r')
            intr_pairs = [ line.split(':') for line in fd.readlines() ]
            fd.close()

            for pair in intr_pairs:
                ints[int(pair[0], 16)] = int(pair[1], 2)

        clk = self.dut.clock
        clk_driver = cocotb.fork(self.clock_gen(clk))
        clkedge = RisingEdge(clk)
        self.dut.iteration = iteration
        yield self.reset(clk, self.dut.metaReset, self.dut.reset)
        self.dut.eos = 0
        self.adapter.start(memory, ints)
        for i in range(max_cycles):
            yield clkedge

            if i % 100 == 0:
                tohost = memory[tohost_addr]
                if tohost:
                    self.dut.eos = 1  # chath: set end of sim
                    break
                else:
                    self.adapter.probe_tohost(tohost_addr)

        self.dut.eos = 1
        yield self.adapter.stop()
        clk_driver.kill()

        # Check all the CPU's memory access operations occurs in DRAM
        mem_check = True
        for addr in memory.keys():
            if addr not in bootrom_addrs and addr < DRAM_BASE:
                print("{:08x}".format(addr))
                mem_check = False

        if not mem_check:
            return (ILL_MEM, self.get_covsum())

        if i == max_cycles - 1:
            self.debug_print('[RTLHost] Timeout, max_cycle={}'.format(max_cycles))
            return (TIME_OUT, self.get_covsum())

        if self.adapter.check_assert():
            self.debug_print('[RTLHost] Assertion Failure')
            return (ASSERTION_FAIL, self.get_covsum())

        self.save_signature(memory, sig_start, sig_end, data_addrs, self.rtl_sig_file)
        self.debug_print('[RTLHost] Stop RTL simulation')

        return (SUCCESS, self.get_covsum(), self.get_path())
