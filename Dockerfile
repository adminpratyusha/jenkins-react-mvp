FROM nginx:latest

# Create a directory to store your application files
WORKDIR /usr/share/nginx/html

# Copy the contents of the local 'build' folder to the container's working directory
COPY build/ .

EXPOSE 80
# The default command to run when the container starts (this starts Nginx)
CMD ["nginx", "-g", "daemon off;"]
