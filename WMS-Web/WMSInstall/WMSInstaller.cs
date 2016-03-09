using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Data.SqlClient;
using System.IO;
using System.Xml;
using Microsoft.Win32;
using System.Diagnostics;
using System.Data.Xiao;
using System.Reflection;

namespace WMSInstall
{
    [RunInstaller(true)]
    public partial class WMSInstaller : Installer
    {
        private string strServer = "";
        private string strUser = "";
        private string strPass = "";


        public WMSInstaller()
        {
            InitializeComponent();
        }

        public override void Install(System.Collections.IDictionary stateSaver)
        {
            strServer = this.Context.Parameters["server"];
            strUser = this.Context.Parameters["user"];
            strPass = this.Context.Parameters["pass"];

            if (!IsSQLServerInstalled())
                return;

            string strConn = String.Format("data source={0};user id={1};password={2};", strServer, strUser, strPass);

            //WMSDatabase数据库是否存在
            if (!IsDataBaseExist("WMSDatabase"))
            {
                this.ExecuteSQL(strConn, "master", "CREATE DATABASE WMSDatabase");
            }

            //导入作业
            this.ExecuteSQL(strConn, "master", GetSql("ScheduleJob.sql"));

            string strDataFile = this.Context.Parameters["targetdir"] + @"\WMSDatabase.bak";
            //DbRestore(strDataFile);
            DbOper myDbOper = new DbOper(strServer, strUser, strPass, "WMSDatabase");
            string strMessage = myDbOper.DbRestore(strDataFile);
            //改写WMS的web.config
            WriteWebConfig();

            base.Install(stateSaver);
        }

        private bool IsSQLServerInstalled()
        {
            RegistryKey hklm = Registry.LocalMachine;
            RegistryKey software = hklm.OpenSubKey(@"SOFTWARE\Microsoft\Microsoft SQL Server");
            return software != null;
        }

        private bool IsDataBaseExist(string strDataBase)
        {
            SQLDMO.SQLServer srv = new SQLDMO.SQLServerClass();
            srv.Connect(strServer, strUser, strPass);

            bool ret = false;
            for (int i = 0; i < srv.Databases.Count; i++)
            {
                if (srv.Databases.Item(i + 1, "dbo").Name == strDataBase)
                {
                    ret = true;
                    break;
                }
            }
            srv.DisConnect();
            return ret;
        }

        protected void WriteWebConfig()
        {
            try
            {
                FileInfo file = new FileInfo(this.Context.Parameters["targetdir"] + @"\Web.config");
                XmlDocument doc = new XmlDocument();
                doc.Load(file.FullName);
                XmlElement root = doc.DocumentElement;
                XmlNodeList list = root.SelectNodes("/configuration/connectionStrings/add");
                foreach (XmlNode node in list)
                {
                    switch (node.Attributes["name"].Value)
                    {
                        case "MySqlProviderConnection":
                        case "LocalSqlServer":
                            node.Attributes["connectionString"].Value = "server="+strServer+";trusted_connection=false;user id="+
                                strUser+";pwd="+strPass+";database=WMSDatabase";
                            break;
                        case "MySqlMasterProviderConnection":
                            node.Attributes["connectionString"].Value = "server=" + strServer + ";trusted_connection=false;user id=" +
                                strUser + ";pwd=" + strPass + ";database=master"; 
                            break;
                        default:
                            break;

                    }
                }
                doc.Save(file.FullName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ExecuteSQL(string strConn, string DatabaseName, string Sql)
        {

            SqlConnection sqlConnection1 = new SqlConnection(strConn);
            SqlCommand Command = new SqlCommand(Sql, sqlConnection1);
            Command.Connection.Open();
            Command.Connection.ChangeDatabase(DatabaseName);
            try
            {
                Command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                Command.Connection.Close();
            }
        }

        private string GetSql(string strName)
        {
            try
            {
                Assembly Asm = Assembly.GetExecutingAssembly();
                Stream strm = Asm.GetManifestResourceStream(Asm.GetName().Name + "." + strName);
                StreamReader reader = new StreamReader(strm);
                return reader.ReadToEnd();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}