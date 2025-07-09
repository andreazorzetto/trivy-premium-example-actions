# Multi-stage Dockerfile for demonstrating Trivy Premium scanning
# This creates a simple Node.js application with various dependencies

# Stage 1: Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Create package.json with various dependencies (including some with known vulnerabilities for demo)
RUN echo '{ \
  "name": "trivy-demo-app", \
  "version": "1.0.0", \
  "description": "Demo application for Trivy Premium scanning", \
  "main": "server.js", \
  "scripts": { \
    "start": "node server.js" \
  }, \
  "dependencies": { \
    "express": "^4.18.0", \
    "lodash": "^4.17.0", \
    "moment": "^2.29.0", \
    "axios": "^0.21.1" \
  } \
}' > package.json

# Install dependencies
RUN npm install

# Create a simple Express server
RUN echo 'const express = require("express"); \
const app = express(); \
const port = process.env.PORT || 3000; \
\
app.get("/", (req, res) => { \
  res.json({ \
    message: "Trivy Premium Demo Application", \
    version: "1.0.0", \
    timestamp: new Date().toISOString() \
  }); \
}); \
\
app.get("/health", (req, res) => { \
  res.status(200).json({ status: "healthy" }); \
}); \
\
app.listen(port, () => { \
  console.log(`Demo app listening at http://localhost:${port}`); \
});' > server.js

# Stage 2: Runtime stage
FROM node:18-alpine

# Add metadata labels
LABEL maintainer="demo@aquasec.com" \
      description="Demo application for Trivy Premium scanning" \
      version="1.0.0"

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy application files from builder
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/server.js ./

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); })"

# Start the application
CMD ["node", "server.js"]