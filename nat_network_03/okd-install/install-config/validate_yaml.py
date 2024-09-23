import yaml
import sys

# Cargar y validar el archivo YAML
try:
    with open('install-config.yaml', 'r') as f:
        data = yaml.safe_load(f)
        print("El archivo YAML es válido.")
except yaml.YAMLError as exc:
    print(f"Error en el archivo YAML: {exc}")
    sys.exit(1)
    