# Use an official node image as a parent image
FROM node:14-alpine

# Set the working directory
WORKDIR /app

RUN mkdir dist

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the application
RUN npm run build

# Install serve to serve the build
RUN npm install -g serve

# Remove unnecessary files to reduce the image size
RUN rm -rf node_modules src public

# Set the command to start the application
CMD ["serve", "-s", "dist"]
