//template class for the reports that are being generated. Allows us to set it as a data type.
class ReportData {
  //used to hold the average of each data section
  double overall;
  double prodKnow;
  double prodFeas;
  double markKnow;
  double markFeas;
  double custKnow;
  double custExe;
  double compKnow;
  double compExe;
  double foundExpMark;
  double foundBizExp;
  double coachableFound;

  //used to hold the min and max of each data section
  int minOverall;
  int minProdKnow;
  int minProdFeas;
  int minMarkKnow;
  int minMarkFeas;
  int minCustKnow;
  int minCustExe;
  int minCompKnow;
  int minCompExe;
  int minFoundExpMark;
  int minFoundBizExp;
  int minCoachableFound;
  int maxOverall;
  int maxProdKnow;
  int maxProdFeas;
  int maxMarkKnow;
  int maxMarkFeas;
  int maxCustKnow;
  int maxCustExe;
  int maxCompKnow;
  int maxCompExe;
  int maxFoundExpMark;
  int maxFoundBizExp;
  int maxCoachableFound;

  ReportData({
    this.overall,
    this.prodKnow,
    this.prodFeas,
    this.markKnow,
    this.markFeas,
    this.custKnow,
    this.custExe,
    this.compKnow,
    this.compExe,
    this.foundExpMark,
    this.foundBizExp,
    this.coachableFound,
    this.minOverall,
    this.minProdKnow,
    this.minProdFeas,
    this.minMarkKnow,
    this.minMarkFeas,
    this.minCustKnow,
    this.minCustExe,
    this.minCompKnow,
    this.minCompExe,
    this.minFoundExpMark,
    this.minFoundBizExp,
    this.minCoachableFound,
    this.maxOverall,
    this.maxProdKnow,
    this.maxProdFeas,
    this.maxMarkKnow,
    this.maxMarkFeas,
    this.maxCustKnow,
    this.maxCustExe,
    this.maxCompKnow,
    this.maxCompExe,
    this.maxFoundExpMark,
    this.maxFoundBizExp,
    this.maxCoachableFound,
  });
}