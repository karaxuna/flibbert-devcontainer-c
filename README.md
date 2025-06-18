## Flibbert devcontainer c
This is a devcontainer for developing applications for Flibbert with clang. Any time code changes in `/src` folder, project will be built and pushed to the device.

### Setup
1. Follow [instructions](https://code.visualstudio.com/docs/devcontainers/tutorial) to setup docker and devcontainer;
2. Clone the flibbert devcontainer repo:

```bash
git clone https://github.com/karaxuna/flibbert-devcontainer-c.git
```

3. Create `.env` file with following env vars:

```
FLIBBERT_DEVICE_ID=<your_device_id>
FLIBBERT_TOKEN=<your_flibbert_token>
```

4. Press <kbd>Shift</kbd> + <kbd>⌘</kbd> + <kbd>P</kbd> (macOS) or <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> (Win/Linux) and choose `Dev Containers: Open Folder in Container`.
