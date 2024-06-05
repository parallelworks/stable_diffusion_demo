## Stable Diffusion Workflow

### Instructions

1. **Enter Prompt and Sample Count**
   - Specify the prompt and the number of samples you want to generate using the Stable Diffusion model.

2. **Access Generated Images**
   - Generated images will be stored in the job directory: `~/pw/jobs/<workflow-name>/<job-number>/samples`.
   - This directory is accessible from your workspace at: `/clusters/<cluster-name>/`.
   - Double-click on the images to display them on the platform.

### Important Notes

- **GPU Requirement**
  - This workflow requires instances with GPUs to run.

- **Initial Setup**
  - On the first run in a new cluster session, dependencies will be installed in `~/pw/bootstrap`, which may take some time.
  - Subsequent runs will be faster since the dependencies are already installed.
