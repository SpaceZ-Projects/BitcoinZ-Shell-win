import subprocess
import os

def run_batch_file(file_path):
    subprocess.run([file_path], shell=True, check=True)

if __name__ == "__main__":
    
    batch_file_path = os.path.join(os.path.dirname(__file__), 'start.bat')
    run_batch_file(batch_file_path)
