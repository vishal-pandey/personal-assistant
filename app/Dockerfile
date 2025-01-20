# Use an official Apache image as the base image
FROM httpd:alpine

# Set the working directory
WORKDIR /usr/local/apache2/htdocs

# Copy the application files (HTML, CSS, JS) to the container
COPY ./ /usr/local/apache2/htdocs

# Expose the default Apache port
EXPOSE 80

# Start Apache
CMD ["httpd-foreground"]
