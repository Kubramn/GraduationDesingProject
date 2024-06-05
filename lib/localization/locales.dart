import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> locales = [
  MapLocale("tr", LocaleData.tr),
  MapLocale("en", LocaleData.en),
];

mixin LocaleData {
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
  //
  static const String statusWaiting = "statusWaiting";
  static const String statusAcceptedByLeader = "statusAcceptedByLeader";
  static const String statusAcceptedByLeaderAndFinance =
      "statusAcceptedByLeaderAndFinance";
  static const String statusDenied = "statusDenied";
  //
  static const String statusDashboardWaiting = "statusDashboardWaiting";
  static const String statusDashboardAcceptedByLeader =
      "statusDashboardAcceptedByLeader";
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
  //
  static const String error = "error";
  static const String errorNoPreviousExpense = "errorNoPreviousExpense";
  static const String errorNoWaitingExpense = "errorNoWaitingExpense";
  static const String errorNoTeamExpense = "errorNoTeamExpense";
  static const String errorNotEnoughData = "errorNotEnoughData";
  static const String errorNoData = "errorNoData";

  static const Map<String, dynamic> tr = {
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
    //
    "statusWaiting":
        "Bu harcama, takım lideri ve finansın onayını beklemektedir.",
    "statusAcceptedByLeader":
        "Bu harcama, takım lideriniz tarafından onaylandı ancak finansın onayını beklemektedir.",
    "statusAcceptedByLeaderAndFinance": "Bu harcama onaylandı.",
    "statusDenied": "Bu harcama reddedildi.",
    //
    "statusDashboardWaiting":
        " ve takım lideri ile finansın onayını beklemektedir.",
    "statusDashboardAcceptedByLeader":
        " ve sizin tarafından onaylandı ancak finansın onayını beklemektedir.",
    "statusDashboardAcceptedByLeaderAndFinance": " ve onaylandı.",
    "statusDashboardDenied": " ve reddedildi.",
    //
    "categoryTravel": "Seyahat ve Ulaşım",
    "categoryMeal": "Yemek ve Eğlence",
    "categoryOffice": "Ofis Malzemeleri ve Ekipmanları",
    "categoryOther": "Diğer Harcamalar",
    //
    "addExpenseButton": "Harcamayı Ekle",
    //
    "error": "HATA",
    "errorNoPreviousExpense": "Geçmiş bir harcamanız bulunmamaktadır.",
    "errorNoWaitingExpense": "Onay bekleyen bir harcamanız bulunmamaktadır.",
    "errorNoTeamExpense": "Takımınızın herhangi bir harcaması bulunmamaktadır.",
    "errorNotEnoughData": "Yetersiz Veri",
    "errorNoData": "Veri bulunamadı.",
  };

  static const Map<String, dynamic> en = {
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
    //
    "statusWaiting":
        "This expense is currently awaiting approval from the team leader and the finance.",
    "statusAcceptedByLeader":
        "This expense has been accepted by your team leader but is currently awaiting approval from the finance.",
    "statusAcceptedByLeaderAndFinance": "This expense has been accepted.",
    "statusDenied": "This expense has been denied.",
    //
    "statusDashboardWaiting":
        " and is currently awaiting approval from the team leader and the finance.",
    "statusDashboardAcceptedByLeader":
        " and has been accepted by you but is currently awaiting approval from the finance.",
    "statusDashboardAcceptedByLeaderAndFinance": " and has been accepted.",
    "statusDashboardDenied": " and has been denied.",
    //
    "categoryTravel": "Travel and Transportation",
    "categoryMeal": "Meals and Entertainment",
    "categoryOffice": "Office Supplies and Equipment",
    "categoryOther": "Other Expenses",
    //
    "addExpenseButton": "Add Expense",
    //
    "error": "ERROR",
    "errorNoPreviousExpense":
        "There is no previous expense of yours right now.",
    "errorNoWaitingExpense":
        "There is no expense of yours awaiting approval right now.",
    "errorNoTeamExpense": "There is no expense from your team right now.",
    "errorNotEnoughData": "Not Enough Data",
    "errorNoData": "No data available.",
  };
}
