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
  int? SelectedSubcategoryindex;
  String? SelectedStatename;
  int? SelectedStateindex;
  String? SelectedOrganizationname;
  int? SelectedOrganizationindex;
  String? SelectedSDistrictname;
  int? SelectedSDistrictindex;

  List<StateModel> states = [];
  List<DistrictModel> districts = [];
  List<Organization> organizations = [];
  List<Product_new> products = [];

  Future<void> getsubcategorydetails(
      List<SubCategory_new> subcategories, String selectedname) async {
    emit(GetSubCategoryDetailScreenLoadingState());
    subcategorieslist = subcategories;
    SelectedSubcategoryname = selectedname;
    var selectedSubCategory = subcategorieslist!.firstWhere(
      (id) => id.name == SelectedSubcategoryname,
    );
    final index = subcategorieslist!.indexOf(selectedSubCategory);
    SelectedSubcategoryindex = index;
    print("Selected subcategory index: $index");
    UpdateproductAccordingtoCategory(selectedSubCategory.id);

    await getallstate();

    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategories, selectedname: selectedname));
  }

  void selectSubCategory(String newValue, int index) {
    emit(GetSubCategoryDetailScreenLoadingState());

    SelectedSubcategoryname = newValue;
    SelectedSubcategoryindex = index;
    districts.clear();
    states.clear();
    organizations.clear();

    emit(GetAllDistrictSuccessState(district: districts, name: ''));
    emit(GetAllStateSuccessState(states: states, name: ''));
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));

    if (!subcategorieslist![index].isState) {
      UpdateproductAccordingtoCategory(subcategorieslist![index].id);
    } else {
      UpdateproductAccordingtoCategory(subcategorieslist![index].id);
      getallstate();
    }

    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategorieslist!,
        selectedname: SelectedSubcategoryname!));
  }

  Future<void> getallstate() async {
    emit(GetAllStateLoadingState());
    try {
      if (subcategorieslist != null &&
          subcategorieslist![SelectedSubcategoryindex!].isState == true) {
        final stateResponse = await SubCategoryRepo.getallstate();
        states = stateResponse;
        states.insert(0, StateModel(id: 0, name: 'Select State'));

        if (states.isNotEmpty) {
          emit(GetAllStateSuccessState(states: states, name: ''));
        } else {
          UpdateproductAccordingtoCategory(
              subcategorieslist![SelectedSubcategoryindex!].id);
          emit(GetAllOrganizationSuccessState(
              organization: organizations, name: SelectedSubcategoryname!));
        }
      } else {
        UpdateproductAccordingtoCategory(
            subcategorieslist![SelectedSubcategoryindex!].id);
      }
    } catch (e) {
      emit(GetAllStateFailedState(message: 'Failed to fetch states'));
    }
  }

  void selectState(String name, int index) {
    SelectedStatename = name;
    SelectedStateindex = index;
    emit(GetAllStateSuccessState(states: states, name: SelectedStatename!));
    UpdateProductAccordingtoState(states[SelectedStateindex!].id,
        subcategorieslist![SelectedSubcategoryindex!].id);
    getdistrict();
  }

  Future<void> getdistrict() async {
    emit(GetAllDistrictLoadingState());
    try {
      if (subcategorieslist?[SelectedSubcategoryindex!] != null &&
          subcategorieslist![SelectedSubcategoryindex!].isDistrict == true) {
        final districtresponse = await SubCategoryRepo.getalldistrict(
            states[SelectedStateindex!].id);
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
      } else if (subcategorieslist?[SelectedSubcategoryindex!] != null &&
          subcategorieslist![SelectedSubcategoryindex!].isOrganization ==
              true) {
        emit(GetAllDistrictSuccessState(district: districts, name: ''));
        getorganization();
      } else {
        emit(GetAllDistrictSuccessState(district: districts, name: ''));
        UpdateProductAccordingtoState(states[SelectedStateindex!].id,
            subcategorieslist![SelectedSubcategoryindex!].id);
      }
    } catch (e) {
      emit(GetAllDistrictFailedState(message: 'Failed to fetch districts'));
    }
  }

  void selectdistrict(String name, int index) {
    SelectedSDistrictname = name;
    SelectedSDistrictindex = index;
    organizations.clear();
    emit(GetAllOrganizationSuccessState(organization: organizations, name: ''));
    UpdateProductAccordingtoDistrict(
        states[SelectedStateindex!].id,
        subcategorieslist![SelectedSubcategoryindex!].id,
        districts[SelectedSDistrictindex!].id);
    getorganization();
    emit(GetAllDistrictSuccessState(
        district: districts, name: SelectedSDistrictname!));
  }

  Future<void> getorganization() async {
    emit(GetAllOrganizationLoadingState());
    try {
      if (districts.isNotEmpty &&
          subcategorieslist![SelectedSubcategoryindex!].isOrganization ==
              true) {
        final organizationresponse =
            await SubCategoryRepo.getorganizationacctodistrict(
                districts[SelectedSDistrictindex!].id);
        organizations = organizationresponse;
        organizations.insert(
            0,
            Organization(
                districtId: 0,
                districtName: SelectedSDistrictname ?? 'Select District',
                subCategoryId: 0,
                subCategoryName:
                    SelectedSubcategoryname ?? 'Select Subcategory',
                id: 0,
                name: SelectedOrganizationname ?? 'Select Organization',
                stateId: 0,
                stateName: SelectedStatename ?? 'Select State'));
        if (organizations.isNotEmpty) {
          emit(GetAllOrganizationSuccessState(
              organization: organizations, name: ''));
        } else {
          emit(
              GetAllOrganizationFailedState(message: 'No organizations found'));
        }
      } else {
        final organizationresponse =
            await SubCategoryRepo.getorganizationacctostate(
                states[SelectedStateindex!].id);
        organizations = organizationresponse;
        organizations.insert(
            0,
            Organization(
                districtId: 0,
                districtName: SelectedSDistrictname ?? 'Select District',
                subCategoryId: 0,
                subCategoryName:
                    SelectedSubcategoryname ?? 'Select Subcategory',
                id: 0,
                name: SelectedOrganizationname ?? 'Select Organization',
                stateId: 0,
                stateName: SelectedStatename ?? 'Select State'));
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

  void selectOrganization(String name, int index) {
    SelectedOrganizationname = name;
    SelectedOrganizationindex = index;
    UpdateproductAccordingtoCategory(
        organizations[SelectedOrganizationindex!].id);
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

  Future<void> UpdateProductAccordingtoState(int stateid, int subid) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    try {
      final response = await SubCategoryRepo.getProductsByState(stateid, subid);

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

  Future<void> UpdateProductAccordingtoDistrict(
      int id, int id2, int id3) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    try {
      final response =
          await SubCategoryRepo.getProductsByDistrict(id, id2, id3);

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
}
