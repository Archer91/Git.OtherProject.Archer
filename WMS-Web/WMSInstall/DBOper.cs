using System;
using System.Data.SqlClient;
using System.Data;

namespace System.Data.Xiao
{

    /// <summary>

    /// DbOper类,主要应用SQLDMO实现对Microsoft SQL Server数据库的备份和恢复

    /// </summary>

    public class DbOper
    {

        private string server;

        private string uid;

        private string pwd;

        private string database;

        private string conn;

        /// <summary>

        /// DbOper类的构造函数

        /// </summary>

        public DbOper(string strServer, string strUser, string strPass, string strDataBase)
        {

            server = strServer;

            uid = strUser;

            pwd = strPass;

            database = strDataBase;

        }

        public string cut(string str, string bg, string ed)
        {

            string sub;

            sub = str.Substring(str.IndexOf(bg) + bg.Length);

            if (sub.IndexOf(ed) != -1)
                sub = sub.Substring(0, sub.IndexOf(ed));

            return sub;

        }

        private string CreatePath(string createpath)
        {
            string CurrTime = System.DateTime.Now.ToString("yyyyMMddHHmmss");
            CurrTime = CurrTime.Substring(0, 12);
            string spath = createpath;
            spath += database;
            spath += "_db_";
            spath += CurrTime;
            spath += ".bak";
            return spath;
        }

        /// <summary>

        /// 数据库备份

        /// </summary>

        public bool DbBackup(string url)
        {
            string path = CreatePath(url);

            SQLDMO.Backup oBackup = new SQLDMO.BackupClass();

            SQLDMO.SQLServer oSQLServer = new SQLDMO.SQLServerClass();

            try
            {

                oSQLServer.LoginSecure = false;

                oSQLServer.Connect(server, uid, pwd);

                oBackup.Action = SQLDMO.SQLDMO_BACKUP_TYPE.SQLDMOBackup_Database;

                oBackup.Database = database;

                oBackup.Files = path;

                oBackup.BackupSetName = database;

                oBackup.BackupSetDescription = "数据库备份";

                oBackup.Initialize = true;

                oBackup.SQLBackup(oSQLServer);

                return true;
            }

            catch (Exception e)
            {
                return false;
                throw e;
            }

            finally
            {

                oSQLServer.DisConnect();

            }

        }



        /// <summary>

        /// 数据库恢复

        /// </summary>

        public string DbRestore(string url)
        {

            if (exepro() != true)//执行存储过程
            {

                return "操作失败";

            }

            else
            {

                SQLDMO.Restore oRestore = new SQLDMO.RestoreClass();

                SQLDMO.SQLServer oSQLServer = new SQLDMO.SQLServerClass();

                try
                {

                    oSQLServer.LoginSecure = false;

                    oSQLServer.Connect(server, uid, pwd);

                    oRestore.Action = SQLDMO.SQLDMO_RESTORE_TYPE.SQLDMORestore_Database;

                    oRestore.Database = database;

                    oRestore.Files = url;//@"d:\Northwind.bak";

                    oRestore.FileNumber = 1;

                    oRestore.ReplaceDatabase = true;

                    oRestore.SQLRestore(oSQLServer);

                    return "成功恢复数据库。";

                }

                catch (Exception e)
                {

                    return "恢复数据库失败";

                    throw e;

                }

                finally
                {

                    oSQLServer.DisConnect();

                }

            }

        }

        public bool exepro()
        {

            SqlConnection conn1 = new SqlConnection("server=" + server + ";uid=" + uid + ";pwd=" + pwd + ";database=master");

            SqlCommand cmd = new SqlCommand("killspid", conn1);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@dbname", database);

            try
            {

                conn1.Open();

                cmd.ExecuteNonQuery();

                return true;

            }

            catch (Exception ex)
            {

                return false;

            }
            finally
            {
                conn1.Close();
            }
        }
    }
}