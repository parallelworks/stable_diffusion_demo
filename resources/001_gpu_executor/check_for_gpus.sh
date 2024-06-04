
echo; echo; echo "CHECKING FOR GPUs"
# Run the nvidia-smi command
nvidia-smi > /dev/null 2>&1

# Check the exit code of the nvidia-smi command
if [ $? -eq 0 ]; then
    echo "GPUs are available."
    # Optionally, you can print the output of nvidia-smi if GPUs are available
    nvidia-smi
else
    echo "ERROR: No GPUs found or nvidia-smi command not available."
    exit 1
fi