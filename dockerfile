# Stage 1: Base Stage
FROM node:22.14.0-alpine AS base
LABEL maintainer="teachteam@bidinn.in"

# Install build dependencies
RUN apk add --no-cache python3 make g++

# # Set non-root user for security
# USER node

WORKDIR /usr/src/app

# Stage 2: Dependency Installation
FROM base AS dependencies

# Install dependencies
COPY package.json ./
RUN yarn install --frozen-lockfile --production=false

# Copy configuration files for the build process
COPY tsconfig*.json nest-cli.json ./

# Stage 3: Build Application
FROM dependencies AS builder

# Copy the application code and build
COPY --chown=node:node . .
RUN yarn build

# Stage 4: Install Production Dependencies
FROM base AS production-deps

# Install only production dependencies
COPY package.json ./
RUN yarn install --frozen-lockfile --production=true

# Stage 5: Final Lightweight Image
FROM node:22.14.0-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy production dependencies and built files
COPY --from=production-deps /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist

# Copy essential files
COPY package.json ./
# Include certificates directory
COPY ./certs /usr/src/app/certs

# Set environment variables
ENV NODE_ENV=prod

# Expose application port
ARG PORT=5000
ENV PORT=${PORT}
EXPOSE ${PORT}

# Start the application
CMD [ "yarn", "start:prod" ]
