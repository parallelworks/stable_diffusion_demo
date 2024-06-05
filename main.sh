#!/bin/bash
source inputs.sh

# Use the resource wrapper
source /etc/profile.d/parallelworks.sh
source /etc/profile.d/parallelworks-env.sh
source /pw/.miniconda3/etc/profile.d/conda.sh

if [ -z "${workflow_utils_branch}" ]; then
    # If empty, clone the main default branch
    git clone https://github.com/parallelworks/workflow-utils.git
else
    # If not empty, clone the specified branch
    git clone -b "$workflow_utils_branch" https://github.com/parallelworks/workflow-utils.git
fi

conda activate
python3 ./workflow-utils/input_form_resource_wrapper.py 

if [ $? -ne 0 ]; then
    echo "Error: Input form resource wrapper failed. Exiting."
    exit 1
fi

source workflow-utils/workflow-libs.sh
source resources/001_gpu_executor/inputs.sh
export sshcmd="ssh -o StrictHostKeyChecking=no ${resource_username}@${resource_publicIp}"


echo; echo; echo "CREATING RUN SCRIPT"
if [[ ${jobschedulertype} == "SLURM" ]]; then 
    cp resources/001_gpu_executor/batch_header.sh run_stable_diffusion.sh
else
    echo '#!/bin/bash' > run_stable_diffusion.sh
fi

cat resources/001_gpu_executor/inputs.sh >> run_stable_diffusion.sh
cat resources/001_gpu_executor/check_for_gpus.sh >> run_stable_diffusion.sh
cat resources/001_gpu_executor/install.sh >> run_stable_diffusion.sh
cat resources/001_gpu_executor/txt2img.sh >> run_stable_diffusion.sh
chmod +x run_stable_diffusion.sh

echo; echo; echo "TRANSFERRING RUN SCRIPT"
${sshcmd} mkdir -p ${resource_jobdir}
resource_script_path=${resource_jobdir}/run_stable_diffusion.sh
scp run_stable_diffusion.sh ${resource_username}@${resource_publicIp}:${resource_script_path}

echo; echo; echo "SUBMITTING JOB"
if [[ ${jobschedulertype} == "SLURM" ]]; then
    export jobid=$(${sshcmd} ${submit_cmd} ${resource_script_path} | tail -1 | awk -F ' ' '{print $4}')
    echo "${sshcmd} ${cancel_cmd} ${jobid}" >> cancel.sh
    wait_job
else
    ${sshcmd} bash ${resource_script_path}
    # Exit script with the exit code of the above command
    exit $?
fi

