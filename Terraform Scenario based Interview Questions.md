# 1. You have multiple environments - dev, stage, prod for your application and you want to use the same code for all of these environment. How can you do that?
- To use the same code across multiple environments like dev, stage, and prod, while managing the environment-specific differences, I would follow these practices:
1. **Environment Variables**:  
    - I would use environment variables to manage environment-specific configurations like database URLs, API keys, etc. Each environment would have its own set of environment variables, ensuring the same code works with different settings in each environment.
2. **Configuration Files**:  
    - I would create environment-specific configuration files (e.g., `config.dev.json`, `config.prod.json`). The application would load the appropriate configuration based on the environment it's running in.

3. **CI/CD Pipeline**:  
    -  In the CI/CD pipeline, I would set up different stages for each environment (dev, stage, prod). Each stage would deploy using the correct environment variables and configuration files.

4. **Infrastructure as Code (IaC)**:  
    -  If using tools like Terraform, I would define environment-specific configurations and resources, ensuring consistent and automated deployment across environments.

---








   
