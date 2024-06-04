
cd ${resource_workdir}/pw/bootstrap/stable-diffusion/
python3 ${resource_workdir}/pw/bootstrap/stable-diffusion/scripts/txt2img.py --prompt "${sd_prompt}" --plms --ckpt sd-v1-4.ckpt --skip_grid --n_samples ${sd_n_samples} --outdir ${resource_jobdir}