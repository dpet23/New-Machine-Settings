New Machine Settings
======

###### A set of PowerShell scripts to set up the settings of a new Windows 10 machine.


## The scripts:
| Name                     | What it does          |
| ------------------------ | --------------------- |
| Settings_Apps            | Adds the Windows 7 Photo Viewer alongside Photos, enables the F8 boot menu, and installs the Windows Subsystem for Linux |
| Settings_Browsers        | Settings for Microsoft Edge and Internet Explorer |
| Settings_Devices         | Settings app -> Devices |
| Settings_File_Explorer   | Common settings for File Explorer |
| Settings_Interface       | Various UI settings |
| Settings_Personalisation | Settings app -> Personalization |
| Settings_Privacy         | Settings app -> Privacy |
| Settings_Region          | Settings app -> Time & Language |
| Settings_System          | Settings app -> System |
| Settings_Updates         | Settings app -> Updates |
| Variables                | Called by other scripts only. Contains variables and functions. |

## Running:
Before the scripts can be run, PowerShell's Execution Policy needs to be changed to `RemoteSigned` or `Unrestricted`.
1. Open PowerShell with Administrator privileges.
2. Run one of the following commands:
   * `Set-ExecutionPolicy RemoteSigned`
   * `Set-ExecutionPolicy Unrestricted`
3. Open the scripts in PowerShell Integrated Scripting Environment (ISE) and check which settings will be applied. Uncomment the settings you wish to be applied, and comment out the settings you do not wish to be applied.
4. Run the scripts with Administrator privileges.
5. Reboot the computer to finalise the changes.

## License:
GNU General Public License v3

You may copy, distribute, and modify the software as long as you track the changes in the source files. Any modifications must also be made available under the GPL-3.

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranty of fitness for a particular purpose. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.

See the LICENSE.md file for more information.
