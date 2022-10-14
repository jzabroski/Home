Taken from: https://www.visualcron.com/forum.aspx?g=Posts&m=38014#post38014
```c#
using System;
using System.Data.SqlClient;
using System.Runtime.ConstrainedExecution;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Permissions;
using System.Security.Principal;
using Microsoft.Win32.SafeHandles;

namespace GroupManagedServiceAccounts
{
    class Program
    {
        /*
         1. Create an AD Group msaTest_Principals
         2. Add the computer you wish to run this code on to the AD Group msaTest_Principals
         3. Create an MSA account using PowerShell: New-ADServiceAccount -name msaTest -DNSHostName msaTest.YOURDOMAIN.com -PrincipalsAllowedToRetrieveManagedPassword msaTest_Principals
         4. Reboot the computer from step #2 to install the GMSA
         5. Download PSExec from SysInternals so we can run this application as SYSTEM (the same account that we run VisualCron under)
         6. Compile this application a C# console application (replace YOURDOMAIN with your domain)
         7. Run psexec.exe -s -i cmd.exe to start a new command window running as system
         8. In the new command window run the executable generated from this code
         9. Troubleshoot any error codes using the Windows Security Event Log
         */

        public const int LOGON32_LOGON_SERVICE = 5;
        public const int LOGON32_PROVIDER_DEFAULT = 0;
        public const string NETWORK_LOGIN_PASSWORD = "_SA_{262E99C9-6160-4871-ACEC-4E61736B6F21}";

        [PermissionSet(SecurityAction.Demand, Name = "FullTrust")]
        public static void Main(string[] args)
        {
            SafeTokenHandle safeTokenHandle;
            try
            {
                var username = "msaTest$";
                var domain = "YOURDOMAIN";

                // Call LogonUser to obtain a handle to an access token.
                bool returnValue = LogonUser(username, domain, NETWORK_LOGIN_PASSWORD, LOGON32_LOGON_SERVICE, LOGON32_PROVIDER_DEFAULT, out safeTokenHandle);

                Console.WriteLine("LogonUser called.");

                if (false == returnValue)
                {
                    int ret = Marshal.GetLastWin32Error();
                    Console.WriteLine("LogonUser failed with error code : {0}", ret);
                    throw new System.ComponentModel.Win32Exception(ret);
                }

                using (safeTokenHandle)
                {
                    Console.WriteLine("Did LogonUser Succeed? " + (returnValue ? "Yes" : "No"));
                    Console.WriteLine("Value of Windows NT token: " + safeTokenHandle);

                    // Check the identity.
                    Console.WriteLine("Before impersonation: " + WindowsIdentity.GetCurrent().Name);
                    // Use the token handle returned by LogonUser.
                    using (var impersonatedUser = WindowsIdentity.Impersonate(safeTokenHandle.DangerousGetHandle()))
                    {

                        // Check the identity.
                        Console.WriteLine("After impersonation: " + WindowsIdentity.GetCurrent().Name);

                        //Validate the security credential is used for accessing the network/SQL
                        //using (var connection = new SqlConnection("server=(local);integrated security=true;"))
                        //{
                        //    connection.Open();
                        //    using (var cmd = connection.CreateCommand())
                        //    {
                        //        cmd.CommandText = "SELECT 'Hello'";
                        //        using (var reader = cmd.ExecuteReader())
                        //        {
                        //            reader.Read();
                        //            Console.WriteLine(reader.GetString(0));
                        //        }
                        //    }
                        //}
                    }

                    // Releasing the context object stops the impersonation
                    // Check the identity.
                    Console.WriteLine("After closing the context: " + WindowsIdentity.GetCurrent().Name);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception occurred. " + ex.Message);
            }
            finally
            {
                Console.Read();
            }

        }

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        public static extern bool LogonUser(string lpszUsername, string lpszDomain, string lpszPassword, int dwLogonType, int dwLogonProvider, out SafeTokenHandle phToken);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        public static extern bool CloseHandle(IntPtr handle);
    }

    public sealed class SafeTokenHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        private SafeTokenHandle()
            : base(true)
        {
        }

        [DllImport("kernel32.dll")]
        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
        [SuppressUnmanagedCodeSecurity]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool CloseHandle(IntPtr handle);

        protected override bool ReleaseHandle()
        {
            return CloseHandle(handle);
        }
    }
}
```
