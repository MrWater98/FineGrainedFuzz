import os
import random
from copy import deepcopy
import pickle

from inst_generator import Word, rvInstGenerator, PREFIX, MAIN, SUFFIX

""" Mutation phases """
GENERATION = 0
MUTATION   = 1
MERGE      = 2

""" Template versions """
P_M = 0
P_S = 1
P_U = 2

# V_M = 3
# V_S = 3
V_U = 3

templates = [ 'p-m', 'p-s', 'p-u',
              'v-u']

class simInput():
    def __init__(self, prefix: list, words: list, suffix: list, ints: list, data_seed: int, template: int):
        self.prefix = prefix
        self.words = words
        self.suffix = suffix
        self.ints = ints

        self.num_prefix = len(prefix)
        self.num_words = len(words)
        self.num_suffix = len(suffix)

        self.data_seed = data_seed
        self.template = template
        self.it = 0
        self.name_suffix = '' 
        
        self.visited_path = []
        self.explr_point = float(0)
        self.uncov_alt_br = float(0)
        self.dep_point = float(0)
        self.assign_dist = 0
        

    def save(self, name, data=[]):
        prefix_insts = self.get_prefix()
        insts = self.get_insts()
        suffix_insts = self.get_suffix()

        fd = open(name, 'w')
        fd.write('{}\n\n'.format(templates[self.template]))

        for inst in prefix_insts[:-1]:
            fd.write('{:<50}\n'.format(inst))

        for (inst, INT) in zip(insts, self.ints):
            fd.write('{:<50}{:04b}\n'.format(inst, INT))

        for inst in suffix_insts[:-1]:
            fd.write('{:<50}\n'.format(inst))

        if data:
            fd.write('data:\n')
            for word in data:
                fd.write('{:016x}\n'.format(word))

        fd.close()

    def get_seed(self):
        return self.data_seed

    def get_template(self):
        return self.template

    def get_prefix(self):
        insts = []
        for word in self.prefix:
            insts += word.get_insts()

        insts.append(PREFIX + '{}:'.format(self.num_prefix))
        return insts

    def get_insts(self):
        insts = []
        for word in self.words:
            insts += word.get_insts()

        insts.append(MAIN + '{}:'.format(self.num_words))
        return insts

    def get_suffix(self):
        insts = []
        for word in self.suffix:
            insts += word.get_insts()

        insts.append(SUFFIX + '{}:'.format(self.num_suffix))
        return insts
    
    def set_visit_path(self, visit_path, CFG):
        new_visit_path = []
        for item in visit_path:
            if item in CFG['count_to_assign']:
                count_value = CFG['count_to_assign'].get(item)
                self.visited_path.append(CFG['assign_to_block'][count_value])
                new_visit_path.append(item)

        # 清空原始的 visit_path 列表
        visit_path.clear()

        # 将新的路径添加到 visit_path 列表中
        visit_path.extend(new_visit_path)



class rvMutator():
    def __init__(self, max_data_seeds=100, corpus_size=2000, no_guide=False, top_module=None):
        self.corpus_size = corpus_size
        self.corpus = []

        self.phases = [GENERATION, MUTATION, MERGE]
        self.phase = GENERATION

        
        self.num_prefix = 3
        self.num_words = 100
        
        self.num_suffix = 5

        self.max_nWords = 200
        self.no_guide = no_guide

        
        self.max_data = max_data_seeds
        self.random_data = {}
        self.data_seeds = []

        self.inst_generator = rvInstGenerator('RV64G')
        
        self.cul_path = {}
        self.CFG = self.get_cfg_cul_path(top_module=top_module)
        # assign_dist should be a dictionary, key is the unvisited block id, we only collect distance within 5
        self.assign_dist = {}
        
        


    def add_data(self, new_data=[]):
        if len(self.data_seeds) == self.max_data:
            seed = self.data_seeds.pop(0)
        else:
            seed = len(self.data_seeds)

        if new_data:
            self.random_data[seed] = new_data
        else:
            self.random_data[seed] = [ random.randint(0, 0xffffffffffffffff) for i in range(64 * 6)] # TODO, Num_data_sections = 6
        self.data_seeds.append(seed)

        return seed

    def update_data_seeds(self, seed):
        assert self.data_seeds.count(seed) == 1, \
            '{} entrie(s) of {} exist in Mutator data_seeds'. \
            format(self.data_seeds.count(seed), seed)

        idx = self.data_seeds.index(seed)
        self.data_seeds.pop(idx)
        self.data_seeds.append(seed)

    def read_label(self, line, tuples):
        label = line[:8].split(':')[0]
        label_num = int(label[2:])

        insts = []
        tuples.append((label_num, insts))

        return tuples

    def tuples_to_words(self, tuples, part):
        words = []

        for tup in tuples:
            label = tup[0]
            insts = tup[1]

            word = Word(label, insts)
            word.populate({}, part)

            words.append(word)

        return words

    def read_siminput(self, si_name):
        fd = open(si_name, 'r')
        lines = fd.readlines()
        fd.close()

        ints = []
        prefix_tuples = []
        word_tuples = []
        suffix_tuples = []
        data = []

        num_prefix = 0
        num_word = 0
        num_suffix = 0

        part = None
        tmp_tuples = None
        num_tmp = None

        template_word = lines.pop(0).split('\n')[0]
        template = templates.index(template_word)
        lines.pop(0)
        while True:
            try: line = lines.pop(0)
            except: break

            if 'data:' in line:
                part = None
                while True:
                    try: word = lines.pop(0)
                    except: break

                    data.append(int(word, 16))
                break
            elif line[:2] == PREFIX:
                part = PREFIX
                num_prefix += 1
                tmp_tuples = self.read_label(line, prefix_tuples)
                num_tmp = num_prefix

                tmp_tuples[num_tmp - 1][1].append(line[8:50])
            elif line[:2] == MAIN:
                part = MAIN
                num_word += 1
                tmp_tuples = self.read_label(line, word_tuples)
                num_tmp = num_word
               
                tmp_tuples[num_tmp - 1][1].append(line[8:50])
            elif line[:2] == SUFFIX:
                part = SUFFIX
                num_suffix += 1
                tmp_tuples = self.read_label(line, suffix_tuples)
                num_tmp = num_suffix

                tmp_tuples[num_tmp - 1][1].append(line[8:50])
            else:
                tmp_tuples[num_tmp - 1][1].append(line[8:50])

            if part == MAIN:
                ints.append(int(line[-5:-1], 2))

        prefix = self.tuples_to_words(prefix_tuples, PREFIX)
        words = self.tuples_to_words(word_tuples, MAIN)
        suffix = self.tuples_to_words(suffix_tuples, SUFFIX)

        data_seed = self.add_data(data)
        sim_input = simInput(prefix, words, suffix, ints, data_seed, template)
        data = self.random_data[data_seed]

        assert_intr = False
        if [ i for i in ints if i != 0 ]:
            assert_intr = True

        return (sim_input, data, assert_intr)

    def make_nop(self, sim_input, nop_mask, part):
        data_seed = sim_input.get_seed()
        prefix = sim_input.prefix
        words = sim_input.words
        suffix = sim_input.suffix
        ints = sim_input.ints
        template = sim_input.template

        if part == PREFIX: target = prefix
        elif part == MAIN: target = words
        else: target = suffix

        assert len(target) == len(nop_mask), \
            'Length of words and nop_mask are not equal'

        new_target = []
        for (word, mask) in zip(target, nop_mask):
            if mask:
                new_word = Word(word.label, ['nop'])
                new_word.populate({}, part)
                new_target.append(new_word)
            else:
                new_target.append(word)

        if part == PREFIX:
            min_input = simInput(new_target, words, suffix, ints, data_seed, template)
        elif part == MAIN:
            new_ints = []
            k = 0
            for i in range(len(nop_mask)):
                if nop_mask[i]:
                    new_ints += [0] * new_target[i].len_insts
                else:
                    new_ints += [ ints[k + j] for j in range(new_target[i].len_insts) ]

                k += new_target[i].len_insts

            min_input = simInput(prefix, new_target, suffix, new_ints, data_seed, template)
        else:
            min_input = simInput(prefix, words, new_target, ints, data_seed, template)

        data = self.random_data[data_seed]
        return (min_input, data)

    def delete_nop(self, sim_input):
        data_seed = sim_input.get_seed()
        prefix = sim_input.prefix
        words = sim_input.words
        suffix = sim_input.suffix
        ints = sim_input.ints
        template = sim_input.template

        words_map = {}
        new_ints = []
        k = 0
        for (part, target) in zip([PREFIX, MAIN, SUFFIX], [prefix, words, suffix]):
            tmps = []
            for word in target:
                if word.insts != ['nop']:
                    new_word = deepcopy(word)
                    tmps.append(new_word)

                if part == MAIN:
                    if word.insts != ['nop']:
                        new_ints += ints[k:k+word.len_insts]
                    k += word.len_insts

            new_target = self.reset_labels(tmps, part)
            words_map[part] = new_target

        del_input = simInput(words_map[PREFIX], words_map[MAIN], words_map[SUFFIX], new_ints, data_seed, template)
        data = self.random_data[data_seed]

        return (del_input, data)

    def update_corpus(self, corpus_dir, update_num=100):
        si_files = os.listdir(corpus_dir)

        num_files = len(si_files)
        start = max(num_files - update_num, 0)
        for i in range(start, num_files):
            try:
                (sim_input, _) = self.read_siminput(corpus_dir +
                                                    '/id_{}.si'.format(i))
                self.add_corpus(sim_input)
            except:
                continue

    def reset_labels(self, words, part):
        n = 0

        label_map = {}
        for (n, word) in enumerate(words):
            tup = word.reset_label(n, part)
            if tup:
                label_map[tup[0]] = tup[1]

        max_label = len(words)

        for word in words:
            word.repop_label(label_map, max_label, part)

        return words

    def mutate_words(self, seed_words, part, max_num):
        words = []

        for word in seed_words:
            rand = random.random()
            if rand < 0.5:
                words.append(word)
            elif rand < 0.75:
                words.append(word)
                new_word = self.inst_generator.get_word(part)
                words.append(new_word)

        words = words[0:max_num]
        words = self.reset_labels(words, part)

        return words

    def get(self, it, assert_intr=False):
        i_len = 0
        prefix = []
        words = []
        suffix = []
        name_suffix = ''
        self.inst_generator.reset()

        data_seed = -1
        template = -1
        if self.phase == GENERATION:
            for n in range(self.num_prefix):
                word = self.inst_generator.get_word(PREFIX)
                prefix.append(word)
            for n in range(self.num_words):
                word = self.inst_generator.get_word(MAIN)
                words.append(word)
            for n in range(self.num_suffix):
                word = self.inst_generator.get_word(SUFFIX)
                suffix.append(word)
            name_suffix = '_gen'
        elif self.phase in [ MUTATION, MERGE ]:
            if self.phase == MUTATION:
                # print("explr_point",self.corpus[0].explr_point)
                # print("uncov_alt",self.corpus[0].uncov_alt_br)
                # print("assign_dist",self.corpus[0].assign_dist)
                
                rand = random.random()
                fitness_explr = [indiv.explr_point for indiv in self.corpus]
                [seed_si1] = random.choices(self.corpus, fitness_explr)
                if rand < 0.2:
                    self.calculate_depdency()
                    fitness_uncov = [indiv.dep_point for indiv in self.corpus]
                    [seed_si2] = random.choices(self.corpus, fitness_uncov)
                    seed_si = random.choice([seed_si1, seed_si2])
                else:
                    seed_si = seed_si1
                seed_si = random.choice([seed_si1])
                
                # [seed_si] = random.choices(self.corpus)
                seed_prefix = deepcopy(seed_si.prefix)
                seed_words = deepcopy(seed_si.words)
                seed_suffix = deepcopy(seed_si.suffix)
                data_seed = seed_si.get_seed()
                template = seed_si.get_template()
                name_suffix = '_mut_'+str(seed_si.it)
                #base = seed_si.it
            else:
                seed_words = []
                # print("explr_point",self.corpus[0].explr_point)
                # print("uncov_alt",self.corpus[0].uncov_alt_br)
                # print("assign_dist",self.corpus[0].assign_dist)
                rand = random.random()
                fitness_explr = [indiv.explr_point for indiv in self.corpus]
                
                [seed_si11, seed_si12] = random.choices(self.corpus, fitness_explr, k=2)
                if rand < 0.2:
                    self.calculate_depdency()
                    fitness_uncov = [indiv.dep_point for indiv in self.corpus]
                    [seed_si21, seed_si22] = random.choices(self.corpus, fitness_uncov, k=2)
                    [seed_si1, seed_si2] = random.choices([seed_si11, seed_si12,seed_si21,seed_si22], k=2)
                else:
                    [seed_si1, seed_si2] = [seed_si11, seed_si12]
                # [seed_si1, seed_si2] = random.choices([seed_si11, seed_si12], k=2)
                # [seed_si1, seed_si2] = random.choices(self.corpus, k=2)

                seed_prefix = deepcopy(seed_si1.prefix)
                si1_words = deepcopy(seed_si1.words)
                si2_words = deepcopy(seed_si2.words)
                seed_suffix = deepcopy(seed_si1.suffix)
                idx = random.randint(0, min(len(si1_words),
                                            len(si2_words)))

                for i in range(idx):
                    seed_words.append(si1_words[i])
                for i in range(idx, len(si2_words)):
                    
                    seed_words.append(si2_words[i])
                data_seed = seed_si1.get_seed()
                template = seed_si1.get_template()

                name_suffix = '_mer_' + str(seed_si1.it) + '_' + str(seed_si2.it)

            prefix = self.mutate_words(seed_prefix, PREFIX, self.num_prefix)
            words = self.mutate_words(seed_words, MAIN, self.max_nWords)
            suffix = self.mutate_words(seed_suffix, SUFFIX, self.num_suffix)

        for word in prefix:
            self.inst_generator.populate_word(word, len(prefix), PREFIX)

        max_label = len(words)
        for word in words:
            i_len += word.len_insts
            self.inst_generator.populate_word(word, max_label, MAIN)

        for word in suffix:
            self.inst_generator.populate_word(word, len(suffix), SUFFIX)

        ints = [ 0 for i in range(i_len) ]
        if assert_intr:
            idx = random.randint(0, min(len(ints), 10) - 1)
            INT = random.randint(0x1, 0xf)
            ints[idx] = INT

        if data_seed == -1:
            data_seed = self.add_data()
        else:
            self.update_data_seeds(data_seed)

        if template == -1:
            template = random.randint(0, V_U)
        #print(words)
        sim_input = simInput(prefix, words, suffix, ints, data_seed, template)
        sim_input.it = it
        sim_input.name_suffix = name_suffix
        data = self.random_data[data_seed]

        return (sim_input, data)

    def calculate_exploration(self):
        for item in self.corpus:
            item.explr_point = 0
            for i in range(0,len(item.visited_path)):
                item.explr_point += 1 / self.cul_path[item.visited_path[i]]
    
    def calculate_depdency(self):
        for item in self.corpus:
            item.dep_point = 0
        for item in self.corpus:
            for i in range(0,len(item.visited_path)):
                queue = [(item.visited_path[i],0)]
                break_flag = False
                while not break_flag:
                    if queue == []:
                        break
                    cur = queue.pop(0)
                    if cur[0] in self.CFG:
                        cur_block = self.CFG[cur[0]]
                        for succ in cur_block['successors']:
                            if succ in self.cul_path and self.cul_path[succ] == 0:
                                item.dep_point += 1 / (cur[1]+1)
                                break_flag = True
                                break
                            if cur[1]+1<=3:
                                queue.append((succ,cur[1]+1))
                        
    
    def calculate_uncov_alt(self):
        for item in self.corpus:
            item.uncov_alt_br = 0
        for item in self.corpus:
            visited_alt = {}
            for i in range(0,len(item.visited_path)):
                if item.visited_path[i] in self.CFG:
                    cur_block = self.CFG[item.visited_path[i]]
                    visited_alt[item.visited_path[i]] = True
                    # depth 1
                    if cur_block['orig_idom']!=[]:
                        cur_orig_idom = cur_block['orig_idom'][0]
                        for _item in self.CFG[cur_orig_idom]['successors']:
                            if _item not in visited_alt and _item in self.cul_path and self.cul_path[_item] == 0:
                                visited_alt[_item] = True
                                item.uncov_alt_br += 1
                                break
                        # depth 2
                        if self.CFG[cur_orig_idom]['orig_idom']!=[]:
                            cur_orig_idom2 = self.CFG[cur_orig_idom]['orig_idom'][0]
                            for __item in self.CFG[cur_orig_idom2]['successors']:
                                if __item not in visited_alt and __item in self.cul_path and self.cul_path[__item] == 0:
                                    visited_alt[__item] = True
                                    item.uncov_alt_br += 0.5
                                    break
                            # depth 3
                            if self.CFG[cur_orig_idom2]['orig_idom']!=[]:
                                cur_orig_idom3 = self.CFG[cur_orig_idom2]['orig_idom'][0]
                                for ___item in self.CFG[cur_orig_idom3]['successors']:
                                    if ___item not in visited_alt and ___item in self.cul_path and self.cul_path[___item] == 0:
                                        visited_alt[___item] = True
                                        item.uncov_alt_br += 1.0/3.0
                                        break
        # a = 1
    
    def calculate_unvisited_assign_dist(self):
        self.CFG['assign_block'] = set(self.CFG['assign_block'])
        for key in self.cul_path:
            if self.cul_path[key] == 0:
                stack = [key]
                dict_depth = {key: 0}
                keys_to_remove = []
                # calculate the distance within 4
                while stack:
                    cur = stack.pop()
                    if cur in dict_depth and dict_depth[cur] <= 3:
                        for pred in self.CFG[cur]['predecessors']:
                            if pred not in dict_depth:
                                if pred not in self.CFG['assign_block']:
                                    dict_depth[pred] = dict_depth[cur] + 1
                                else:
                                    dict_depth[pred] = dict_depth[cur]
                                    keys_to_remove.append(pred)
                                stack.append(pred)
                dict_depth.pop(key)
                for item in keys_to_remove:
                    dict_depth.pop(item)
                self.assign_dist[key] = dict_depth
                
        for sim_input in self.corpus:
            _min = 9999
            for node in sim_input.visited_path:
                for key in self.assign_dist:
                    if node in self.assign_dist[key]:
                        _min = min(_min,self.assign_dist[key][node])
            sim_input.assign_dist = _min
                
    

    def update_phase(self, it):
        global visit_assign_dist
        if it < self.corpus_size / 10 or self.no_guide:
            self.phase = GENERATION
        else:
            rand = random.random()
            if rand < 0.1:
                self.phase = GENERATION
            elif rand < 0.55:
                self.calculate_exploration()
                self.phase = MUTATION
            else:
                self.calculate_exploration()
                self.phase = MERGE

    def add_corpus(self, sim_input):
        self.corpus.append(sim_input)

        self.num_words = min(self.num_words + 1, self.max_nWords)
        if len(self.corpus) > self.corpus_size:
            self.corpus.pop(0)      

    def get_cfg_cul_path(self, top_module):
        if top_module == None:
            raise ValueError('top_module is None')
        file_pkl = f'../CFG/{top_module}_cfg.pkl'
        with open(file_pkl, 'rb') as file:
            data = pickle.load(file)
        
        for key,value in data['count_to_assign'].items():
            block = data['assign_to_block'][value]
            self.cul_path[block] = 0
        
        return data
        
    def accumulate_coverage(self, path):
        for i in range(len(path)):
            if path[i] in self.cul_path:
                self.cul_path[path[i]] += 1
            else:
                self.cul_path[path[i]] = 1
        cur_cov = 0
        # print acculumate coverage
        for key, value in self.cul_path.items():
            if value > 0:
                idom = self.CFG[key]['orig_idom']
                if idom != [] and idom[0] in self.cul_path and self.cul_path[idom[0]] == 0:
                    self.cul_path[idom[0]] = value
        for key, value in self.cul_path.items():
            if value > 0:
                cur_cov += 1
        print(f'Current coverage: {cur_cov/len(self.cul_path)*100}%')