# Use an official Python image instead of Ubuntu
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements and application code to the container
COPY requirments.txt /app/
COPY SecurePixel /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirments.txt

# Expose the port your Django app runs on
EXPOSE 8000

# Run the Django application
ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]

