import json
import yaml

def format_install_config(pull_secret_path, install_config_template, output_path):
    # Load the pull-secret from the provided file
    try:
        with open(pull_secret_path, 'r') as f:
            pull_secret_content = f.read()
        # Convert pull secret content to a single-line JSON string
        pull_secret_json = json.loads(pull_secret_content)
        pull_secret_str = json.dumps(pull_secret_json)

        # Load the install-config.yaml template
        with open(install_config_template, 'r') as f:
            install_config = yaml.safe_load(f)

        # Update the pullSecret field with the correctly formatted string
        install_config['pullSecret'] = pull_secret_str

        # Write the new install-config.yaml with the updated pull secret
        with open(output_path, 'w') as f:
            yaml.dump(install_config, f, default_flow_style=False)

        print(f"Formatted install-config.yaml has been saved to {output_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage:
pull_secret_path = 'path_to_pull_secret.txt'
install_config_template = 'path_to_install_config_template.yaml'
output_path = 'path_to_output_install_config.yaml'

format_install_config(pull_secret_path, install_config_template, output_path)