import pickle

def read_pickle_file(file_path):
    try:
        with open(file_path, 'rb') as file:
            data = pickle.load(file)
            return data
    except FileNotFoundError:
        print(f"File {file_path} not found.")
    except pickle.UnpicklingError:
        print(f"Error unpickling file {file_path}.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    file_path = '/root/Fuzz_RTL/CFG/BoomTile_cfg.pkl'
    data = read_pickle_file(file_path)
    if data is not None:
        print("Data read from pickle file:")
        print(data)