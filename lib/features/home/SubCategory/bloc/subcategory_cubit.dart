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
  List<Product_new> products = [];

  Future<void> getsubcategorydetails(
      List<SubCategory_new> subcategories, String selectedname) async {
    emit(GetSubCategoryDetailScreenLoadingState());
    subcategorieslist = subcategories;
    SelectedSubcategoryname = selectedname;
    var selectedSubCategory = subcategorieslist!.firstWhere(
      (id) => id.name == SelectedSubcategoryname,
    );
    UpdateproductAccordingtoCategory(selectedSubCategory.id);

    await getallstate();

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
      // Handle error case
      emit(UpdateProductUsingSubCategoryFailedState());
    }
  }

  Future<void> UpdateProductAccordingtoState(int id) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    try {
      final response = await SubCategoryRepo.getProductsByState(id);

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
      // Handle error case
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

    // Using firstWhere to search for the subcategory
    var selectedSubCategory = subcategorieslist!.firstWhere(
      (id) => id.name == SelectedSubcategoryname,
    );

    if (!selectedSubCategory.isState) {
      UpdateproductAccordingtoCategory(selectedSubCategory.id);
    } else {
      UpdateproductAccordingtoCategory(selectedSubCategory.id);
      getallstate();
    }

    emit(GetSubCategoryDetailScreenSuccessState(
        subcategories: subcategorieslist!,
        selectedname: SelectedSubcategoryname!));
  }

  Future<void> getallstate() async {
    emit(GetAllStateLoadingState());

    try {
      // Using firstWhere to find the subcategory
      final subcategory = subcategorieslist?.firstWhere(
        (item) => item.name == SelectedSubcategoryname,
        orElse: () => SubCategory_new(
          id: 0,
          name: '',
          img: '',
          isDistrict: false,
          isState: false,
          isOrganization: false,
        ),
      );

      if (subcategory != null && subcategory.isState == true) {
        final stateResponse = await SubCategoryRepo.getallstate();
        states = stateResponse;
        states.insert(0, StateModel(id: 0, name: 'Select State'));

        if (states.isNotEmpty) {
          emit(GetAllStateSuccessState(states: states, name: ''));
        } else {
          // Handling no states found case with UpdateproductAccordingtoCategory
          UpdateproductAccordingtoCategory(subcategory.id);
          emit(GetAllOrganizationSuccessState(
              organization: organizations, name: SelectedSubcategoryname!));
        }
      } else {
        // No state handling case with UpdateproductAccordingtoCategory
        UpdateproductAccordingtoCategory(subcategory?.id ?? 0);
      }
    } catch (e) {
      emit(GetAllStateFailedState(message: 'Failed to fetch states'));
    }
  }

  void selectState(String name) {
    SelectedStatename = name;
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

    getdistrict();
  }

  Future<void> getdistrict() async {
    emit(GetAllDistrictLoadingState());
    try {
      final subcategory = subcategorieslist?.firstWhere(
          (item) => item.name == SelectedSDistrictname,
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
        emit(GetAllDistrictSuccessState(district: districts, name: ''));

        final state = states.firstWhere((s) => s.name == SelectedStatename);
        UpdateProductAccordingtoState(state.id);
      }
    } catch (e) {
      emit(GetAllDistrictFailedState(message: 'Failed to fetch districts'));
    }
  }

  void selectdistrict(String name) {
    SelectedSDistrictname = name;
    organizations.clear();
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
