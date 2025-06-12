using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

class Program
{
    static void Main()
    {
        string exeDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        string ps1Path = Path.Combine(exeDir, "runasdomainuser.ps1");

        if (!File.Exists(ps1Path))
        {
            Console.Error.WriteLine("runasdomainuser.ps1 not found in application directory.");
            return;
        }

        var psi = new ProcessStartInfo
        {
            FileName = "powershell.exe",
            Arguments = $"-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File \"{ps1Path}\"",
            UseShellExecute = false,
            CreateNoWindow = true,
            RedirectStandardOutput = false,
            RedirectStandardError = false
        };

        try
        {
            using (var process = Process.Start(psi))
            {
                process.WaitForExit();
            }
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"Failed to start PowerShell script: {ex.Message}");
        }
    }
}