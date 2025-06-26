import 'package:optimanage/SignIn/UserInfoModel.dart';

class Maindatamodel{
  String? message;
  bool? status;
  int? state;
  UserInfoModel? data;
  // List<Dashboardcount>? dashBoardCount;
  // List<HCPendingCompletdModel>? hCPendingCompletd;
  // List<SurveDetailPending>? surveDetailPending;
  // List<Hoppercontollistmodel>? hoppercontollistmodel;
  // List<District_model>? district_model;
  // List<GetPSbyDistrictModle>? getPSbyDistrictModle;
  // List<ServeyListdataModel>? serveyListdataModel;
  // List<BlockIdModel>? blockIdModel;
  // List<VillageModel>? villageModel;
  // List<ServeyListFillterModel>? serveyListFillterModel;
  // List<StageLocustModel>? stageLocustModel;
  // List<StageHopperModel>? stageHopperModel;
  // List<SurveyModel>? surveyModel;
  // List<LocustColorModel>? locustColorModel;
  // List<LocustSwarmModel>? locustSwarmModel;
  // List<HopperColorModel>? hopperColorModel;
  // List<agrilovvalues_model>? agrilovv_model;
  // List<locustpesticide_model>? locustpesti_model;
  // List<offline_Locust_swarm_model>? Locust_swarm_model;
  // List<offline_Locust_color_model>? Locust_color_model;
  // List<offline_locust_stage_model>? locust_stage_model;
  // List<offline_locust_survey_model>? locust_survey_model;

  Maindatamodel({this.message, this.status, this.state, this.data});

  Maindatamodel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    state = json['State'];
    status = json['Status'];
    data = json['Data'] != null ? new UserInfoModel.fromJson(json['Data']) : null;


    // if (json['data'] != null) {
    //   dashBoardCount = <Dashboardcount>[];
    //   json['data'].forEach((v) {
    //     dashBoardCount!.add( Dashboardcount.fromJson(v));
    //   });
    // }
    // if (json['data'] != null) {
    //   hCPendingCompletd = <HCPendingCompletdModel>[];
    //   json['data'].forEach((v) {
    //     hCPendingCompletd!.add( HCPendingCompletdModel.fromJson(v));
    //   });
    // } if (json['data'] != null) {
    //   surveDetailPending = <SurveDetailPending>[];
    //   json['data'].forEach((v) {
    //     surveDetailPending!.add( SurveDetailPending.fromJson(v));
    //   });
    // }
    //
    // if (json['data'] != null) {
    //   hoppercontollistmodel = <Hoppercontollistmodel>[];
    //   json['data'].forEach((v) {
    //     hoppercontollistmodel!.add( Hoppercontollistmodel.fromJson(v));
    //   });
    // }
    // if (json['data'] != null) {
    //   district_model = <District_model>[];
    //   json['data'].forEach((v) {
    //     district_model!.add( District_model.fromJson(v));
    //   });
    // }
    // if (json['data'] != null) {
    //   getPSbyDistrictModle = <GetPSbyDistrictModle>[];
    //   json['data'].forEach((v) {
    //     getPSbyDistrictModle!.add(GetPSbyDistrictModle.fromJson(v));
    //   });
    // } if (json['data'] != null) {
    //   serveyListdataModel = <ServeyListdataModel>[];
    //   json['data'].forEach((v) {
    //     serveyListdataModel!.add(ServeyListdataModel.fromJson(v));
    //   });
    // }else if(json['data'] is String != null){
    //   serveyListdataModel = json['data'];
    // }
    // if (json['data'] != null) {
    //   blockIdModel = <BlockIdModel>[];
    //   json['data'].forEach((v) {
    //     blockIdModel!.add(BlockIdModel.fromJson(v));
    //   });
    // }else if(json['data'] is String != null){
    //   blockIdModel = json['data'];
    // }
    // if (json['data'] != null) {
    //   villageModel = <VillageModel>[];
    //   json['data'].forEach((v) {
    //     villageModel!.add(VillageModel.fromJson(v));
    //   });
    // }else if(json['data'] is String != null){
    //   villageModel = json['data'];
    // }
    // if (json['surveylist'] != null) {
    //   serveyListFillterModel = <ServeyListFillterModel>[];
    //   json['surveylist'].forEach((v) {
    //     serveyListFillterModel!.add(ServeyListFillterModel.fromJson(v));
    //   });
    // }else if(json['surveylist'] is String != null){
    //   serveyListFillterModel = json['surveylist'];
    // }
    // if (json['data'] != null) {
    //   stageLocustModel = <StageLocustModel>[];
    //   json['data'].forEach((v) {
    //     stageLocustModel!.add(StageLocustModel.fromJson(v));
    //   });
    // }
    // if (json['data'] != null) {
    //   stageHopperModel = <StageHopperModel>[];
    //   json['data'].forEach((v) {
    //     stageHopperModel!.add( StageHopperModel.fromJson(v));
    //   });
    // } if (json['data'] != null) {
    //   surveyModel = <SurveyModel>[];
    //   json['data'].forEach((v) {
    //     surveyModel!.add( SurveyModel.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   locustColorModel = <LocustColorModel>[];
    //   json['data'].forEach((v) {
    //     locustColorModel!.add(LocustColorModel.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   locustSwarmModel = <LocustSwarmModel>[];
    //   json['data'].forEach((v) {
    //     locustSwarmModel!.add(LocustSwarmModel.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   hopperColorModel = <HopperColorModel>[];
    //   json['data'].forEach((v) {
    //     hopperColorModel!.add(HopperColorModel.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   agrilovv_model = <agrilovvalues_model>[];
    //   json['data'].forEach((v) {
    //     agrilovv_model!.add(agrilovvalues_model.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   locustpesti_model = <locustpesticide_model>[];
    //   json['data'].forEach((v) {
    //     locustpesti_model!.add(locustpesticide_model.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   Locust_swarm_model = <offline_Locust_swarm_model>[];
    //   json['data'].forEach((v) {
    //     Locust_swarm_model!.add(offline_Locust_swarm_model.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   Locust_color_model = <offline_Locust_color_model>[];
    //   json['data'].forEach((v) {
    //     Locust_color_model!.add(offline_Locust_color_model.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   locust_stage_model = <offline_locust_stage_model>[];
    //   json['data'].forEach((v) {
    //     locust_stage_model!.add(offline_locust_stage_model.fromJson(v));
    //   });
    // }if (json['data'] != null) {
    //   locust_survey_model = <offline_locust_survey_model>[];
    //   json['data'].forEach((v) {
    //     locust_survey_model!.add(offline_locust_survey_model.fromJson(v));
    //   });
    // }

  }


}