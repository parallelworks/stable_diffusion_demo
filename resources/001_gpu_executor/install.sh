
mkdir -p ${workdir}/pw/bootstrap/

miniconda_install_dir=${workdir}/pw/bootstrap/miniconda3
conda_repo="https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh"

# Check if the directory exists
if ! [ -d "${miniconda_install_dir}" ]; then
    echo "Installing Miniconda"
    ID=$(date +%s)-${RANDOM}
    wget --no-check-certificate ${conda_repo} -O /tmp/miniconda-${ID}.sh 2>&1
    bash /tmp/miniconda-${ID}.sh -b -p ${miniconda_install_dir} 
fi

source ${miniconda_install_dir}/etc/profile.d/conda.sh

conda activate ldm
if [ $? -ne 0 ]; then
    echo "Installing Stable Diffussion for GPUs"
    cd ${workdir}/pw/bootstrap/
    git clone https://github.com/CompVis/stable-diffusion.git
    cd stable-diffusion/
    conda env create -f environment.yaml
    conda activate ldm
fi

if ! [ -f ${workdir}/pw/bootstrap/stable-diffusion/sd-v1-4.ckpt ]; then
    cd ${workdir}/pw/bootstrap/stable-diffusion/
    curl https://f004.backblazeb2.com/file/aai-blog-files/sd-v1-4.ckpt > sd-v1-4.ckpt
fi

export txt2image_script="${workdir}/pw/bootstrap/stable-diffusion/scripts/txt2img.py"

cd ${resource_jobdir}
