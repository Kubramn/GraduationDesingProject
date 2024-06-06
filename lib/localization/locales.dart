import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> locales = [
  MapLocale("tr", LocaleData.tr),
  MapLocale("en", LocaleData.en),
];

mixin LocaleData {
  static const String name = "name";
  static const String surname = "surname";
  static const String role = "role";
  static const String job = "job";
  static const String department = "department";
  static const String teamName = "teamName";
  static const String budget = "budget";
  static const String email = "email";
  static const String password = "password";
  //
  static const String loginTitle = "loginTitle";
  static const String loginButton = "loginButton";
  //
  static const String navbarExpenses = "navbarExpenses";
  static const String navbarInvoice = "navbarInvoice";
  static const String navbarDashboard = "navbarDashboard";
  static const String navbarRequests = "navbarRequests";
  static const String navbarUsers = "navbarUsers";
  static const String navbarRegister = "navbarRegister";
  //
  static const String previousTab = "previousTab";
  static const String waitingTab = "waitingTab";
  static const String graphicTab = "graphicTab";
  static const String listTab = "listTab";
  //
  static const String dialogTitle = "dialogTitle";
  static const String dialogDescription = "dialogDescription";
  static const String dialogDate = "dialogDate";
  static const String dialogPrice = "dialogPrice";
  static const String dialogCategory = "dialogCategory";
  static const String dialogCloseButton = "dialogCloseButton";
  static const String dialogSupportTitle = "dialogSupportTitle";
  static const String dialogSupportContent = "dialogSupportContent";
  static const String dialogCallButton = "dialogCallButton";
  static const String dialogApplyButton = "dialogApplyButton";
  static const String dialogResetButton = "dialogResetButton";
  static const String dialogDateRangeButton = "dialogDateRangeButton";
  static const String dialogAcceptButton = "dialogAcceptButton";
  static const String dialogDenyButton = "dialogDenyButton";
  //
  static const String dropdownTeam = "dropdownTeam";
  static const String dropdownCategory = "dropdownCategory";
  static const String dropdownStatus = "dropdownStatus";
  static const String dropdownWaiting = "dropdownWaiting";
  static const String dropdownAcceptedByLeader = "dropdownAcceptedByLeader";
  static const String dropdownAcceptedByLeaderAndFinance =
      "dropdownAcceptedByLeaderAndFinance";
  static const String dropdownDenied = "dropdownDenied";
  static const String dropdownUser = "dropdownUser";
  //
  static const String statusWaiting = "statusWaiting";
  static const String statusAcceptedByLeader = "statusAcceptedByLeader";
  static const String statusAcceptedByLeaderAndFinance =
      "statusAcceptedByLeaderAndFinance";
  static const String statusDenied = "statusDenied";
  //
  static const String statusDashboardIntro = "statusDashboardIntro";
  static const String statusRequestsIntro = "statusRequestsIntro";
  static const String statusDashboardWaiting = "statusDashboardWaiting";
  static const String statusLeaderDashboardAcceptedByLeader =
      "statusLeaderDashboardAcceptedByLeader";
  static const String statusFinanceDashboardAcceptedByLeader =
      "statusFinanceDashboardAcceptedByLeader";
  static const String statusDashboardAcceptedByLeaderAndFinance =
      "statusDashboardAcceptedByLeaderAndFinance";
  static const String statusDashboardDenied = "statusDashboardDenied";
  //
  static const String categoryTravel = "categoryTravel";
  static const String categoryMeal = "categoryMeal";
  static const String categoryOffice = "categoryOffice";
  static const String categoryOther = "categoryOther";
  //
  static const String addExpenseButton = "addExpenseButton";
  static const String updateUserButton = "updateUserButton";
  static const String deleteUserButton = "deleteUserButton";
  static const String registerButton = "registerButton";
  //
  static const String error = "error";
  static const String errorNoPreviousExpense = "errorNoPreviousExpense";
  static const String errorNoWaitingExpense = "errorNoWaitingExpense";
  static const String errorNoTeamExpense = "errorNoTeamExpense";
  static const String errorNoTeamRequestLeader = "errorNoTeamRequestLeader";
  static const String errorNoTeamRequestFinance = "errorNoTeamRequestFinance";
  static const String errorNotEnoughData = "errorNotEnoughData";
  static const String errorNoData = "errorNoData";

  static const Map<String, dynamic> tr = {
    "name": "Ad",
    "surname": "Soyad",
    "role": "Rol",
    "job": "Meslek",
    "department": "Departman",
    "teamName": "Takım Adı",
    "budget": "Bütçe",
    "email": "E-posta",
    "password": "Şifre",
    //
    "loginTitle": "Giriş",
    "loginButton": "Giriş Yap",
    //
    "navbarExpenses": "Harcamalar",
    "navbarInvoice": "Fatura",
    "navbarDashboard": "Panel",
    "navbarRequests": "Talepler",
    "navbarUsers": "Kullanıcılar",
    "navbarRegister": "Kayıt",
    //
    "previousTab": "Geçmiş",
    "waitingTab": "Bekleyen",
    "graphicTab": "Grafik",
    "listTab": "Liste",
    //
    "dialogTitle": "Başlık",
    "dialogDescription": "Açıklama",
    "dialogDate": "Tarih",
    "dialogPrice": "Fiyat",
    "dialogCategory": "Kategori",
    "dialogCloseButton": "Kapat",
    "dialogSupportTitle": "Destek",
    "dialogSupportContent":
        "Herhangi bir sorunuz veya probleminiz varsa lütfen bizi arayın.",
    "dialogCallButton": "Ara",
    "dialogApplyButton": "Uygula",
    "dialogResetButton": "Sıfırla",
    "dialogDateRangeButton": "Tarih Aralığı Seçin",
    "dialogAcceptButton": "Onayla",
    "dialogDenyButton": "Reddet",
    //
    "dropdownTeam": "Bir takım seçin...",
    "dropdownCategory": "Bir kategori seçin...",
    "dropdownStatus": "Bir durum seçin...",
    "dropdownWaiting": "Onay bekleniyor.",
    "dropdownAcceptedByLeader": "Sadece takım lideri tarafından onaylandı.",
    "dropdownAcceptedByLeaderAndFinance": "Onaylandı.",
    "dropdownDenied": "Reddedildi.",
    "dropdownUser": "Bir kullanıcı seçin...",
    //
    "statusWaiting":
        "Bu harcama, takım lideri ve finansın onayını beklemektedir.",
    "statusAcceptedByLeader":
        "Bu harcama, takım lideriniz tarafından onaylandı ancak finansın onayını beklemektedir.",
    "statusAcceptedByLeaderAndFinance": "Bu harcama onaylandı.",
    "statusDenied": "Bu harcama reddedildi.",
    //
    "statusDashboardIntro": "Bu harcama, ",
    "statusRequestsIntro": "Bu harcamayı yapan kullanıcı, ",
    "statusDashboardWaiting":
        " tarafından yapıldı ve takım lideri ile finansın onayını beklemektedir.",
    "statusLeaderDashboardAcceptedByLeader":
        " tarafından yapıldı ve sizin tarafınızdan onaylandı ancak finansın onayını beklemektedir.",
    "statusFinanceDashboardAcceptedByLeader":
        " tarafından yapıldı ve takım lideri tarafından onaylandı ancak finansın onayını beklemektedir.",
    "statusDashboardAcceptedByLeaderAndFinance":
        " tarafından yapıldı ve onaylandı.",
    "statusDashboardDenied": " tarafından yapıldı ve reddedildi.",
    //
    "categoryTravel": "Seyahat ve Ulaşım",
    "categoryMeal": "Yemek ve Eğlence",
    "categoryOffice": "Ofis Malzemeleri ve Ekipmanları",
    "categoryOther": "Diğer Harcamalar",
    //
    "addExpenseButton": "Harcamayı Ekle",
    "updateUserButton": "Kullanıcıyı Güncelle",
    "deleteUserButton": "Kullanıcıyı Sil",
    "registerButton": "Kaydet",
    //
    "error": "HATA",
    "errorNoPreviousExpense": "Geçmiş bir harcamanız bulunmamaktadır.",
    "errorNoWaitingExpense": "Onay bekleyen bir harcamanız bulunmamaktadır.",
    "errorNoTeamExpense": "Takımınızın herhangi bir harcaması bulunmamaktadır.",
    "errorNoTeamRequestLeader":
        "Takımınızın herhangi bir harcama talebi bulunmamaktadır.",
    "errorNoTeamRequestFinance": "Herhangi bir harcama talebi bulunmamaktadır.",
    "errorNotEnoughData": "Yetersiz Veri",
    "errorNoData": "Veri bulunamadı.",
  };

  static const Map<String, dynamic> en = {
    "name": "Name",
    "surname": "Surname",
    "role": "Role",
    "job": "Job",
    "department": "Department",
    "teamName": "Team Name",
    "budget": "Budget",
    "email": "Email",
    "password": "Password",
    //
    "loginTitle": "Login",
    "loginButton": "Log In",
    //
    "navbarExpenses": "Expenses",
    "navbarInvoice": "Invoice",
    "navbarDashboard": "Dashboard",
    "navbarRequests": "Requests",
    "navbarUsers": "Users",
    "navbarRegister": "Register",
    //
    "previousTab": "Previous",
    "waitingTab": "Waiting",
    "graphicTab": "Graphic",
    "listTab": "List",
    //
    "dialogTitle": "Title",
    "dialogDescription": "Description",
    "dialogDate": "Date",
    "dialogPrice": "Price",
    "dialogCategory": "Category",
    "dialogCloseButton": "Close",
    "dialogSupportTitle": "Support",
    "dialogSupportContent":
        "Please call us if you have any questions or problems.",
    "dialogCallButton": "Call",
    "dialogApplyButton": "Apply",
    "dialogResetButton": "Reset",
    "dialogDateRangeButton": "Select Date Range",
    "dialogAcceptButton": "Accept",
    "dialogDenyButton": "Deny",
    //
    "dropdownTeam": "Select a team...",
    "dropdownCategory": "Select a category...",
    "dropdownStatus": "Select a status...",
    "dropdownWaiting": "Awaiting approval.",
    "dropdownAcceptedByLeader": "Only accepted by the team leader.",
    "dropdownAcceptedByLeaderAndFinance": "Accepted.",
    "dropdownDenied": "Denied.",
    "dropdownUser": "Select a user to edit or delete...",
    //
    "statusWaiting":
        "This expense is currently awaiting approval from the team leader and the finance.",
    "statusAcceptedByLeader":
        "This expense has been accepted by your team leader but is currently awaiting approval from the finance.",
    "statusAcceptedByLeaderAndFinance": "This expense has been accepted.",
    "statusDenied": "This expense has been denied.",
    //
    "statusDashboardIntro": "This expense was incurred by ",
    "statusRequestsIntro": "This expense was incurred by ",
    "statusDashboardWaiting":
        " and is currently awaiting approval from the team leader and the finance.",
    "statusLeaderDashboardAcceptedByLeader":
        " and has been accepted by you but is currently awaiting approval from the finance.",
    "statusFinanceDashboardAcceptedByLeader":
        " and has been accepted by the team leader but is currently awaiting approval from the finance.",
    "statusDashboardAcceptedByLeaderAndFinance": " and has been accepted.",
    "statusDashboardDenied": " and has been denied.",
    //
    "categoryTravel": "Travel and Transportation",
    "categoryMeal": "Meals and Entertainment",
    "categoryOffice": "Office Supplies and Equipment",
    "categoryOther": "Other Expenses",
    //
    "addExpenseButton": "Add Expense",
    "updateUserButton": "Update User",
    "deleteUserButton": "Delete User",
    "registerButton": "Register",
    //
    "error": "ERROR",
    "errorNoPreviousExpense":
        "There is no previous expense of yours right now.",
    "errorNoWaitingExpense":
        "There is no expense of yours awaiting approval right now.",
    "errorNoTeamExpense": "There is no expense from your team right now.",
    "errorNoTeamRequestLeader":
        "There is no expense request from your team right now.",
    "errorNoTeamRequestFinance": "There is no expense request right now.",
    "errorNotEnoughData": "Not Enough Data",
    "errorNoData": "No data available.",
  };
}
