import subprocess
import os

def run_batch_file(file_path):
    try:
        subprocess.run([file_path], shell=True, check=True)
    except subprocess.CalledProcessError:
        pass

if __name__ == "__main__":
    
    batch_file_path = os.path.join(os.path.dirname(__file__), 'start.bat')
    run_batch_file(batch_file_path)
