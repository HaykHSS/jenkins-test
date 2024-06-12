# First stage: build the application
FROM node:20.14.0-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the application
RUN npm run build

# Second stage: serve the application
FROM node:20.14.0-alpine

# Set the working directory
WORKDIR /app

# Install serve to serve the build
RUN npm install -g serve

# Copy the build files from the first stage
COPY --from=builder /app/dist ./dist

# Set the command to start the application
CMD ["serve", "-s", "dist"]
