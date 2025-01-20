const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { exec } = require('child_process');

let mainWindow;

// Function to create the Electron window
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
    },
  });

  // Load the UI application
  mainWindow.loadURL('http://localhost:8000');

  // Handle window close event
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// Start Docker containers on app launch
function startDocker() {
  const composeFile = path.join(app.getAppPath().replace("electron", ""), 'docker-compose.yaml'); // Locate docker-compose.yml
  const dockerCmd = `docker compose -f "${composeFile}" up -d`;

  exec(dockerCmd, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error starting Docker: ${error.message}`);
      return;
    }
    console.log(`Docker started:\n${stdout}`);
    if (stderr) console.error(`Docker stderr:\n${stderr}`);
  });
}

// App lifecycle events
app.whenReady().then(() => {
  startDocker();
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    exec('docker compose down', (error, stdout, stderr) => {
      if (error) {
        console.error(`Error stopping Docker: ${error.message}`);
      }
    });
    app.quit();
  }
});
