using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;


namespace System.Web.Administration
{
    /// <summary>
    /// Summary description for SecurityPage
    /// </summary>
    public class SecurityPage : Page
    {
        private const string CURRENT_ROLE = "WebAdminCurrentRoleName";
        private const string CURRENT_USER = "WebAdminCurrentUser";
        private const string CURRENT_USER_COLLECTION = "WebAdminUserCollection";
        private const string URL_STACK = "WebAdminUrlStack";

        public SecurityPage()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        protected string CurrentRequestUrl
        {
            get
            {
                Stack stack = (Stack)Session[URL_STACK];
                if (stack != null && stack.Count > 0)
                {
                    return (string)stack.Peek();
                }
                return string.Empty;
            }
        }

        protected string CurrentRole
        {
            get
            {
                object obj = (object)Session[CURRENT_ROLE];
                if (obj != null)
                {
                    return (string)Session[CURRENT_ROLE];
                }
                return String.Empty;
            }
            set
            {
                Session[CURRENT_ROLE] = value;
            }
        }

        protected string CurrentUser
        {
            get
            {
                object obj = (string)Session[CURRENT_USER];
                if (obj != null)
                {
                    return (string)Session[CURRENT_USER];
                }
                return String.Empty;
            }
            set
            {
                Session[CURRENT_USER] = value;
            }
        }

        public Hashtable UserCollection
        {
            get
            {
                Hashtable table = (Hashtable)Session[CURRENT_USER_COLLECTION];
                if (table == null)
                {
                    Session[CURRENT_USER_COLLECTION] = table = new Hashtable();
                }
                return table;
            }
        }

        public void ClearUserCollection()
        {
            Session[CURRENT_USER_COLLECTION] = null;
        }

        protected string PopPrevRequestUrl()
        {
            Stack stack = (Stack)Session[URL_STACK];
            if (stack == null || stack.Count < 2)
            {
                return string.Empty;
            }
            stack.Pop(); // discard current url
            return (string)stack.Pop();
        }

        protected void PushRequestUrl(string s)
        {
            Stack stack = (Stack)Session[URL_STACK];
            if (stack == null)
            {
                Session[URL_STACK] = stack = new Stack();
            }
            stack.Push(s);
        }

        protected void ReturnToPreviousPage(object sender, EventArgs e)
        {
            string prevRequest = PopPrevRequestUrl();
            Response.Redirect(prevRequest, false);  // note: string.Empty ok here.
        }

        protected override void OnInit(EventArgs e)
        {
            if (string.Compare(CurrentRequestUrl, Request.CurrentExecutionFilePath) != 0)
            {
                PushRequestUrl(Request.CurrentExecutionFilePath);
            }

            base.OnInit(e);
        }

        protected void PopulateRepeaterDataSource(Repeater repeater)
        {
            // display alphabet row only if language is has Alphabet resource
            ArrayList arr = new ArrayList();
            String chars = ((string)GetGlobalResourceObject("GlobalResources", "Alphabet"));
            foreach (String s in chars.Split(';'))
            {
                arr.Add(s);
            }
            if (arr.Count == 0)
            {
                repeater.Visible = false;
            }
            else
            {
                arr.Add((string)GetGlobalResourceObject("GlobalResources", "All"));
                repeater.DataSource = arr;
                repeater.Visible = true;
            }
        }

        protected void SearchForUsers(object sender, EventArgs e, Repeater repeater, GridView dataGrid, DropDownList dropDown, TextBox textBox)
        {
            ICollection coll = null;
            string text = textBox.Text;
            text = text.Replace("*", "%");
            text = text.Replace("?", "_");
            int total = 0;

            if (text.Trim().Length != 0)
            {
                if (dropDown.SelectedIndex == 0 /* userID */)
                {
                    coll = Membership.FindUsersByName(text, 0, Int32.MaxValue, out total);
                }
            }

            dataGrid.PageIndex = 0;
            dataGrid.DataSource = coll;
            PopulateRepeaterDataSource(repeater);
            repeater.DataBind();
            dataGrid.DataBind();
        }

        protected void RetrieveLetter(object sender, RepeaterCommandEventArgs e, GridView dataGrid)
        {
            RetrieveLetter(sender, e, dataGrid, (string)GetGlobalResourceObject("GlobalResources", "All"));
        }

        protected void RetrieveLetter(object sender, RepeaterCommandEventArgs e, GridView dataGrid, string all)
        {
            RetrieveLetter(sender, e, dataGrid, all, null);
        }

        protected void RetrieveLetter(object sender, RepeaterCommandEventArgs e, GridView dataGrid, string all, MembershipUserCollection users)
        {
            dataGrid.PageIndex = 0;
            int total = 0;
            string arg = e.CommandArgument.ToString();

            if (arg == all)
            {
                dataGrid.DataSource = (users == null) ? Membership.GetAllUsers( 0, Int32.MaxValue, out total) : users;
            }
            else
            {
                dataGrid.DataSource = Membership.FindUsersByName((string)arg + "%", 0, Int32.MaxValue, out total);
            }
            dataGrid.DataBind();
        }

        public bool IsRuleValid(BaseValidator placeHolderValidator, RadioButton roleRadio, DropDownList roles)
        {
            if (roleRadio.Checked && roles.SelectedItem == null)
            {
                placeHolderValidator.ErrorMessage = ((string)GetGlobalResourceObject("GlobalResources", "NonemptyRole"));
                placeHolderValidator.IsValid = false;
                return false;
            }
            return true;
        }

    }

}
