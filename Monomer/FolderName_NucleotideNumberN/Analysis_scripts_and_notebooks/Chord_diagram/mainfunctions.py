import numpy as np
from pathlib import Path
from oxDNA_analysis_tools.UTILS.RyeReader import describe, get_confs, write_conf, inbox


# Function that reads the HB files .dat from oxDNA simulations
def read_HB_file(file_path):
    data_dict = {}
    
    try: 
        open(file_path,"r")
        state = 1
    except:
        state = 0

    if state == 1:
        with open(file_path, 'r') as file:
            lines = file.readlines()

        current_step = None
        current_pairs = []

        for line in lines:
            line = line.strip()
            if "# step" in line:
                if current_step is not None:
                    data_dict[current_step] = current_pairs
                current_step = int(line.split('#')[0].strip())
                current_pairs = []
            elif line and not line.startswith("#"):
                try:
                    pair = list(map(int, line.split()))
                    current_pairs.append(pair)
                except ValueError:
                    # Skip lines that cannot be converted to pairs
                    continue

        if current_step is not None:
            data_dict[current_step] = current_pairs


    return data_dict


# Function that extracts the maximum catesian distance associated with a certain nucleotide (assuming system is centered in (0,0,0))
def set_R0_externalpotential(trj):
    max_pos =  np.max( [ np.max( [j[i] for j in trj.positions] ) for i in range(3)] );
    min_pos =  np.min( [ np.min( [j[i] for j in trj.positions] ) for i in range(3)] );
    box_size = round( np.max( [max_pos, np.abs(min_pos)] ), 0 )
    return box_size


# Function that reads the output of the observable "external force" in oxDNA
def read_ExternalForce_file(hb_file_path):
    with open(hb_file_path, 'r') as file:
        lines = file.readlines()

    data = []
    step_number = None
    F = {}

    for line in lines:
        stripped_line = line.strip()
        
        if "t" in stripped_line:
            # Start a new block
            step_number = int(stripped_line.split()[4])
            
        elif stripped_line:
            # Check if the line contains a pair of integers
            data.append( [float(k) for k in stripped_line.split()] )
        else:
            # End of a block
            if step_number is not None:
                F[step_number] = np.linalg.norm( np.sum(data,axis=0) )
                step_number = None
                data = []

                
    # # In case the last block doesn't end with an empty line
    if step_number is not None:
        F[step_number] = np.linalg.norm( np.sum(data,axis=0) )
        step_number = None
        data = []

    return F


# Compute the radius of gyration of a oxdna trajectory

def RadiusOfGyration(top_info, traj_info):
    
    time = []; Rg2 = []

    sampling = get_confs(top_info,traj_info,1,1)[0].time-get_confs(top_info,traj_info,0,1)[0].time
    
    for frame in range(0,traj_info.nconfs):
        
        foo = []; conf = []; r_avg = []
        foo = inbox( get_confs(top_info, traj_info, frame,1)[0],1)
        conf.append( foo.positions )        
        r_avg = np.sum(conf,axis=1)/top_info.nbases

        time.append( frame*sampling )
        Rg2.append( np.sum( np.sum( (conf-r_avg)*(conf-r_avg) , axis=1) )/top_info.nbases )
        
    return time, Rg2


def hb_counter(hb_file_path):
    with open(hb_file_path, 'r') as file:
        lines = file.readlines()

    steps = []
    hb_numbers = []
    step_number = None
    count = 0

    for line in lines:
        stripped_line = line.strip()
        # print(stripped_line.split()[1])
        
        if "step" in stripped_line:
            # Save the previous block result if we are starting a new block
            if step_number is not None:
                steps.append(step_number)
                hb_numbers.append(count)
            
            # Start a new block
            step_number = int(stripped_line.split()[3])
            count = 0
        elif stripped_line:
            # Check if the line contains a pair of integers
            if len(stripped_line.split()) == 2:
                count += 1
        else:
            # End of a block
            if step_number is not None:
                steps.append(step_number)
                hb_numbers.append(count)
                # print(hb_numbers)
                step_number = None
                count = 0

    # In case the last block doesn't end with an empty line
    if step_number is not None:
        # steps.append(step_number)
        # hb_numbers.append(count)
        steps = step_number
        hb_numbers = count

    # print(hb_numbers)

    return steps, hb_numbers