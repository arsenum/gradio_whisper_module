# Use the official PyTorch image as the base image
FROM pytorch/pytorch:latest

# Set the working directory
WORKDIR /app
ENV PYTHONUNBUFFERED=1
# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .
RUN chmod +x run_app.sh
# Expose the port the app runs on
# EXPOSE 7860

# Command to run the application
# CMD ["python", "run_app.py"]