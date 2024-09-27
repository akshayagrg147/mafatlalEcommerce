import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_state.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/repo/subcategory_repo.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';

class SubcategoryCubit extends Cubit<SubCategoryDetailState> {
  SubcategoryCubit() : super(SubCategoryDetailInitialState());
  List<SubCategory_new>? subcategorieslist;
  String? SelectedSubcategoryname;
  String? SelectedStatename;
  String? SelectedOrganizationname;
  String? SelectedSDistrictname;

  List<StateModel> states = [];
  List<DistrictModel> districts = [];
  List<Organization> organizations = [];

  Future<void> getsubcategorydetails(
      List<SubCategory_new> subcategories, String selectedname) async {
    emit(GetSubCategoryDetailScreenLoadingState());
    subcategorieslist = subcategories;
    SelectedSubcategoryname = selectedname;
    await getallstate();
    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategories, selectedname: selectedname));
  }

  Future<void> UpdateproductAccordingtoCategory(int id) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    try {
      final response = await SubCategoryRepo.getProductsBySubCatId(id);
      print(response);
      emit(UpdateProductUsingSubCategorySuccessState(
          products: response.data!, organization: organizations.first));
    } catch (e) {
      emit(UpdateProductUsingSubCategoryFailedState());
    }
  }

  void selectSubCategory(String newValue) {
    emit(GetSubCategoryDetailScreenLoadingState());
    SelectedSubcategoryname = newValue;
    districts.clear();
    states.clear();
    organizations.clear();
    emit(GetAllDistrictSuccessState(district: districts, name: ''));
    emit(GetAllStateSuccessState(states: states, name: ''));
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));
    getallstate();
    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategorieslist!,
        selectedname: SelectedSubcategoryname!));
  }

  Future<void> getallstate() async {
    emit(GetAllStateLoadingState());
    try {
      final subcategory = subcategorieslist?.firstWhere(
          (item) => item.name == SelectedSubcategoryname,
          orElse: () => SubCategory_new(
              id: 0,
              name: '',
              img: '',
              isDistrict: false,
              isState: false,
              isOrganization: false));

      if (subcategory != null && subcategory.isState == true) {
        final stateResponse = await SubCategoryRepo.getallstate();
        states = stateResponse;
        if (states.isNotEmpty) {
          emit(GetAllStateSuccessState(states: states, name: ''));
        } else {
          emit(GetAllStateFailedState(message: 'No states found'));
        }
      } else {
        for (var id in subcategorieslist!) {
          if (id.name == SelectedSubcategoryname) {
            fetchorganization(id.id);
          }
        }
      }
    } catch (e) {
      emit(GetAllStateFailedState(message: 'Failed to fetch states'));
    }
  }

  void selectState(String name) {
    SelectedStatename = name;
    districts.clear();
    // states.clear();
    organizations.clear();
    emit(GetAllDistrictSuccessState(district: districts, name: ''));
    // emit(GetAllStateSuccessState(states: states, name: ''));
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));
    getdistrict();
    emit(GetAllStateSuccessState(states: states, name: SelectedStatename!));
  }

  Future<void> getdistrict() async {
    emit(GetAllDistrictLoadingState());
    try {
      final subcategory = subcategorieslist?.firstWhere(
          (item) => item.name == SelectedSubcategoryname,
          orElse: () => SubCategory_new(
              id: 0,
              name: '',
              img: '',
              isDistrict: false,
              isState: false,
              isOrganization: false));

      if (subcategory != null && subcategory.isDistrict == true) {
        final state = states.firstWhere((s) => s.name == SelectedStatename);
        final districtresponse = await SubCategoryRepo.getalldistrict(state.id);
        districts = districtresponse;
        if (districts.isNotEmpty) {
          emit(GetAllDistrictSuccessState(district: districts, name: ''));
          emit(GetAllStateSuccessState(states: states, name: ''));
        } else {
          emit(GetAllDistrictFailedState(message: 'No districts found'));
        }
      }
    } catch (e) {
      emit(GetAllDistrictFailedState(message: 'Failed to fetch districts'));
    }
  }

  void selectdistrict(String name) {
    SelectedSDistrictname = name;
    // districts.clear();
    // states.clear();
    organizations.clear();
    // emit(GetAllDistrictSuccessState(district: districts, name: ''));
    // emit(GetAllStateSuccessState(states: states, name: ''));
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));
    getorganization();
    emit(GetAllDistrictSuccessState(
        district: districts, name: SelectedSDistrictname!));
  }

  Future<void> getorganization() async {
    emit(GetAllOrganizationLoadingState());
    try {
      final subcategory = subcategorieslist?.firstWhere(
          (item) => item.name == SelectedSubcategoryname,
          orElse: () => SubCategory_new(
              id: 0,
              name: '',
              img: '',
              isDistrict: false,
              isState: false,
              isOrganization: false));

      if (subcategory != null && subcategory.isOrganization == true) {
        final district =
            districts.firstWhere((d) => d.name == SelectedSDistrictname);
        final organizationresponse =
            await SubCategoryRepo.getorganization(district.id);
        organizations = organizationresponse;
        if (organizations.isNotEmpty) {
          emit(GetAllOrganizationSuccessState(
              organization: organizations, name: ''));
        } else {
          emit(
              GetAllOrganizationFailedState(message: 'No organizations found'));
        }
      }
    } catch (e) {
      emit(GetAllOrganizationFailedState(
          message: 'Failed to fetch organizations'));
    }
  }

  void selectOrganization(String name) {
    SelectedOrganizationname = name;
    // districts.clear();
    // states.clear();
    // organizations.clear();
    // emit(GetAllDistrictSuccessState(district: districts, name: ''));
    // emit(GetAllStateSuccessState(states: states, name: ''));
    // emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));
    final organization =
        organizations.firstWhere((org) => org.name == SelectedOrganizationname);
    UpdateproductAccordingtoCategory(organization.id);
    emit(GetAllOrganizationSuccessState(
        organization: organizations, name: SelectedOrganizationname!));
  }

  Future<void> fetchorganization(int id) async {
    emit(GetAllOrganizationLoadingState());
    try {
      final organizationresponse =
          await SubCategoryRepo.getorganizationsubit(id);
      organizations = organizationresponse;
      if (organizations.isNotEmpty) {
        states.clear();
        districts.clear();
        emit(GetAllStateSuccessState(states: states, name: ''));
        emit(GetAllDistrictSuccessState(district: districts, name: ''));
        emit(GetAllOrganizationSuccessState(
            organization: organizations, name: ''));
      } else {
        emit(GetAllStateSuccessState(states: states, name: ''));
        emit(GetAllDistrictSuccessState(district: districts, name: ''));
        emit(GetAllOrganizationSuccessState(
            organization: organizations, name: ''));
        // emit(GetAllOrganizationFailedState(message: 'No organizations found'));
      }
    } catch (e) {
      emit(GetAllOrganizationFailedState(
          message: 'Failed to fetch organizations'));
    }
  }
}
