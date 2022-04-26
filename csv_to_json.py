from csv import reader
from sys import platform
from datetime import datetime

def csv_to_json(file_path):    
    with open(file_path, 'r') as f:
        contents = list(reader(f))
    
    columns = contents[0]
    data = contents[1:]
    json = "[\n"
    total_rows = len(data)
    current_row = 1
    
    for row in data:
        print(f'Row {current_row}/{total_rows}')
        record = "{\n"
        for i in range(len(columns)):
            record = record + f'\t"{columns[i]}":"{row[i]}"'
            if i == len(columns) - 1:
                record = record + "\n"
            else:
                record = record + ",\n"
                
        if current_row == total_rows:
            record = record + "}\n"
        else:
            record = record + "},\n"
            
        current_row += 1        
        json = json + record
        
    json = json + "]"
    return json

if platform == "win32":
    path = "C:\\Downloads\\PBI LARGE REPORT.csv"
    result_path = "C:\\Downloads\\results.json"
else:
    path = "/c/Downloads/PBI LARGE REPORT.csv"
    result_path = "/c/Downloads/results.json"

start = datetime.now()

result = csv_to_json(path)
with open(result_path, 'w') as f:
    f.write(result)
end = datetime.now()
delta = end - start
print(f'Parsing took {delta.microseconds}ms')