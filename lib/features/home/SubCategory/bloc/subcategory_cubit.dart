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
  String? bannerImgUrl;

  SubCategory_new? selectedSubCategory;

  List<StateModel> states = [];
  List<DistrictModel> districts = [];
  List<Organization> organizations = [];
  List<Product_new> products = [];

  Future<void> getsubcategorydetails(
      List<SubCategory_new> subcategories, String selectedname) async {
    subcategorieslist = subcategories;
    SelectedSubcategoryname = selectedname;
    SelectedOrganizationname = null;
    SelectedStatename = null;
    SelectedSDistrictname = null;
    bannerImgUrl = null;
    states.clear();
    districts.clear();
    organizations.clear();
    emit(SubCategoryDetailInitialState());
    emit(GetSubCategoryDetailScreenLoadingState());

    emit(GetAllStateSuccessState(states: states, name: ''));
    emit(GetAllDistrictSuccessState(district: districts, name: ''));
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));

    selectedSubCategory = subcategorieslist!.firstWhere(
      (id) => id.name == SelectedSubcategoryname,
    );
    bannerImgUrl = selectedSubCategory!.bannerImg;
    UpdateproductAccordingtoCategory(selectedSubCategory!.id);

    if (selectedSubCategory!.isState) {
      await getallstate();
    } else if (selectedSubCategory!.isOrganization) {
      await getorganization();
    }

    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategories, selectedname: selectedname));
  }

  Future<void> UpdateproductAccordingtoCategory(int id) async {
    emit(UpdateProductUsingSubCategoryLoadingState());

    try {
      final response = await SubCategoryRepo.getProductsBySubCatId(id);

      // Check if response data is empty
      if (response.data == null || response.data!.isEmpty) {
        // Handle the case where no products are returned
        products = [];

        // Check for organizations and handle accordingly
        final organization =
            (organizations.isNotEmpty) ? organizations.first : null;

        emit(UpdateProductUsingSubCategorySuccessState(
          products: products,
          organization: organization,
          orgname: SelectedOrganizationname ??
              '', // It can be null if no organization is available
        ));
      } else {
        // If there are products in the response
        products = response.data!;

        print(response.data!.first.productId);

        // Check for organizations and handle accordingly
        final organization =
            (organizations.isNotEmpty) ? organizations.first : null;

        emit(UpdateProductUsingSubCategorySuccessState(
          products: products,
          organization: organization,
          orgname: SelectedOrganizationname ??
              '', // It can be null if no organization is available
        ));
      }
    } catch (e) {
      emit(UpdateProductUsingSubCategoryFailedState());
    }
  }

  Future<void> UpdateProductAccordingtoState(int subid,
      {int? stateid, int? districtId, int? organisationId}) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    try {
      final response = await SubCategoryRepo.getProductsByState(subid,
          stateId: stateid,
          districtId: districtId,
          organizationId: organisationId);

      if (response.data == null || response.data!.isEmpty) {
        products = [];

        final organization =
            (organizations.isNotEmpty) ? organizations.first : null;

        emit(UpdateProductUsingSubCategorySuccessState(
          products: products,
          organization: organization,
          orgname: SelectedOrganizationname ??
              '', // It can be null if no organization is available
        ));
      } else {
        products = response.data!;
        print(response.data!.first.productId);
        final organization =
            (organizations.isNotEmpty) ? organizations.first : null;
        emit(UpdateProductUsingSubCategorySuccessState(
          products: products,
          organization: organization,
          orgname: SelectedOrganizationname ??
              '', // It can be null if no organization is available
        ));
      }
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
    SelectedSDistrictname = null;
    SelectedStatename = null;
    SelectedOrganizationname = null;

    emit(GetAllDistrictSuccessState(district: districts, name: ''));
    emit(GetAllStateSuccessState(states: states, name: ''));
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));

    // Using firstWhere to search for the subcategory
    selectedSubCategory = subcategorieslist!.firstWhere(
      (id) => id.name == SelectedSubcategoryname,
    );

    bannerImgUrl = selectedSubCategory!.bannerImg;
    UpdateproductAccordingtoCategory(selectedSubCategory!.id);

    if (selectedSubCategory!.isState) {
      getallstate();
    } else if (selectedSubCategory!.isOrganization) {
      getorganization();
    }

    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategorieslist!,
        selectedname: SelectedSubcategoryname!));
  }

  Future<void> getallstate() async {
    emit(GetAllStateLoadingState());

    try {
      if (selectedSubCategory != null && selectedSubCategory!.isState) {
        final stateResponse = await SubCategoryRepo.getallstate();
        states = stateResponse;
        states.insert(0, StateModel(id: 0, name: 'Select State'));

        if (states.isNotEmpty) {
          emit(GetAllStateSuccessState(states: states, name: ''));
        } else {
          UpdateproductAccordingtoCategory(selectedSubCategory!.id);
          emit(GetAllOrganizationSuccessState(
              organization: organizations, name: SelectedSubcategoryname!));
        }
      } else {
        UpdateproductAccordingtoCategory(selectedSubCategory?.id ?? 0);
      }
    } catch (e) {
      emit(GetAllStateFailedState(message: 'Failed to fetch states'));
    }
  }

  void selectState(String name) {
    SelectedStatename = name;
    SelectedSDistrictname = null;
    SelectedOrganizationname = null;
    //
    // districts.clear();
    // // states.clear();
    // organizations.clear();
    // emit(GetAllDistrictSuccessState(
    //     district: districts, name: SelectedSDistrictname!));
    // // emit(GetAllStateSuccessState(states: states, name: ''));
    // emit(GetAllOrganizationSuccessState(
    //     organization: organizations, name: SelectedOrganizationname!));
    emit(GetAllStateSuccessState(states: states, name: SelectedStatename!));
    final state = states.firstWhere(
      (item) => item.name == SelectedStatename,
    );
    final subcategory = subcategorieslist?.firstWhere(
      (item) => item.name == SelectedSubcategoryname,
    );
    UpdateProductAccordingtoState(
      subcategory!.id,
      stateid: state.id,
    );
    getdistrict();
    if (selectedSubCategory!.isOrganization) {
      getorganization(stateId: state.id);
    }
  }

  Future<void> getdistrict() async {
    emit(GetAllDistrictLoadingState());
    try {
      if (selectedSubCategory != null && selectedSubCategory!.isDistrict) {
        final state = states.firstWhere((s) => s.name == SelectedStatename);
        final districtresponse = await SubCategoryRepo.getalldistrict(state.id);
        districts = districtresponse;
        districts.insert(
            0,
            DistrictModel(
                stateName: 'Select State',
                stateId: 0,
                id: 0,
                name: 'Select District'));

        if (districts.isNotEmpty) {
          emit(GetAllDistrictSuccessState(district: districts, name: ''));
        } else {
          emit(GetAllDistrictFailedState(message: 'No districts found'));
        }
      } else {
        // If the subcategory is not a district, proceed with product update
        emit(GetAllDistrictSuccessState(district: districts, name: ''));
        final state = states.firstWhere(
          (item) => item.name == SelectedStatename,
        );
        final subcategory = subcategorieslist?.firstWhere(
          (item) => item.name == SelectedSubcategoryname,
        );
        UpdateProductAccordingtoState(
          subcategory!.id,
          stateid: state.id,
        );
      }
    } catch (e) {
      emit(GetAllDistrictFailedState(message: 'Failed to fetch districts'));
    }
  }

  void selectdistrict(String name) {
    SelectedSDistrictname = name;
    organizations.clear();
    SelectedOrganizationname = null;
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));
    final state = states.firstWhere(
      (item) => item.name == SelectedStatename,
    );
    final district = districts.firstWhere(
      (item) => item.name == SelectedSDistrictname,
    );
    final subcategory = subcategorieslist?.firstWhere(
      (item) => item.name == SelectedSubcategoryname,
    );
    UpdateProductAccordingtoState(
      subcategory!.id,
      stateid: state.id,
      districtId: district.id,
    );

    if (selectedSubCategory!.isOrganization) {
      getorganization(stateId: state.id, districtId: district.id);
    }
    emit(GetAllDistrictSuccessState(
        district: districts, name: SelectedSDistrictname!));
  }

  Future<void> getorganization({int? stateId, int? districtId}) async {
    emit(GetAllOrganizationLoadingState());
    try {
      if (selectedSubCategory != null && selectedSubCategory!.isOrganization) {
        final organizationresponse = await SubCategoryRepo.getorganization(
            selectedSubCategory!.id,
            districtId: districtId,
            stateId: stateId);
        organizations = organizationresponse;
        organizations.insert(
            0,
            Organization(
              id: 0,
              name: SelectedOrganizationname ?? 'Select Organization',
            ));
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
    StateModel? state;
    DistrictModel? district;
    if (SelectedStatename != null) {
      state = states.firstWhere(
        (item) => item.name == SelectedStatename,
      );
    }
    if (SelectedSDistrictname != null) {
      district = districts.firstWhere(
        (item) => item.name == SelectedSDistrictname,
      );
    }

    UpdateProductAccordingtoState(
      selectedSubCategory!.id,
      stateid: state?.id,
      districtId: district?.id,
      organisationId: organization.id,
    );

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
