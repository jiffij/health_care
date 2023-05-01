import 'constant.dart';

class Doctor {
  Doctor(
      {this.doctorName = '',
      this.doctorGender = '',
      this.doctorSpecialty = '',
      this.doctorTel = '',
      this.doctorPrice = '',
      this.doctorRating = '',
      this.doctorHospital = '',
      this.doctorNumberOfPatient = '',
      this.doctorYearOfExperience = '',
      this.doctorDescription = '',
      this.doctorPicture = '',
      this.doctorIsOpen = false});

  String doctorName;
  String doctorGender;
  String doctorSpecialty;
  String doctorTel;
  String doctorPrice;
  String doctorRating;
  String doctorHospital;
  String doctorNumberOfPatient;
  String doctorYearOfExperience;
  String doctorDescription;
  String doctorPicture;
  bool doctorIsOpen;
}

var topDoctors = [
  Doctor(
    doctorName: 'Dr. Gilang Segara',
    doctorGender: 'Male',
    doctorSpecialty: specialtyRange[6],
    doctorTel: '1234 5678',
    doctorPrice: priceRange[2],
    doctorRating: '4.8',
    doctorHospital: 'Persahabatan Hospital',
    doctorNumberOfPatient: '1221',
    doctorYearOfExperience: '3',
    doctorDescription:
        'is one of the best doctors in the Persahabat Hospital. He has saved more than 1000 patients in the past 3 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule.',
    doctorPicture: 'img-men-01.png',
    doctorIsOpen: true
  ),
  Doctor(
    doctorName: 'Dr. Shabil Chan',
    doctorGender: 'Female',
    doctorSpecialty: specialtyRange[5],
    doctorTel: '1234 5678',
    doctorPrice: priceRange[3],
    doctorRating: '4.7',
    doctorHospital: 'Columbia Asia Hospital',
    doctorNumberOfPatient: '964',
    doctorYearOfExperience: '4',
    doctorDescription:
        'is one of the best doctors in the Columbia Asia Hospital. He has saved more than 900 patients in the past 4 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule.',
    doctorPicture: 'img-women-01.png',
    doctorIsOpen: false
  ),
  Doctor(
    doctorName: 'Dr. Mustakim',
    doctorGender: 'Male',
    doctorSpecialty: specialtyRange[3],
    doctorTel: '1234 5678',
    doctorPrice: priceRange[5],
    doctorRating: '4.9',
    doctorHospital: 'Salemba Carolus Hospital',
    doctorNumberOfPatient: '762',
    doctorYearOfExperience: '5',
    doctorDescription:
        'is one of the best doctors in the Salemba Carolus Hospital. He has saved more than 700 patients in the past 5 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule.',
    doctorPicture: 'img-men-02.png',
    doctorIsOpen: true
  ),
  Doctor(
    doctorName: 'Dr. Suprihatini',
    doctorGender: 'Female',
    doctorSpecialty: specialtyRange[2],
    doctorTel: '1234 5678',
    doctorPrice: priceRange[4],
    doctorRating: '4.8',
    doctorHospital: 'Salemba Carolus Hospital',
    doctorNumberOfPatient: '1451',
    doctorYearOfExperience: '6',
    doctorDescription:
        'is one of the best doctors in the Salemba Carolus Hospital. He has saved more than 1400 patients in the past 6 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule.',
    doctorPicture: 'img-women-02.png',
    doctorIsOpen: false
  ),
  Doctor(
    doctorName: 'Dr. Robert Posy',
    doctorGender: 'Male',
    doctorSpecialty: specialtyRange[3],
    doctorTel: '1234 5678',
    doctorPrice: priceRange[2],
    doctorRating: '4.6',
    doctorHospital: 'Kariadi Hospital',
    doctorNumberOfPatient: '551',
    doctorYearOfExperience: '3',
    doctorDescription:
        'is one of the best doctors in the Kariadi Carolus Hospital. He has saved more than 500 patients in the past 3 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule.',
    doctorPicture: 'img-men-03.png',
    doctorIsOpen: true
  ),
  Doctor(
    doctorName: 'Dr. Matilde Hani',
    doctorGender: 'Female',
    doctorSpecialty: specialtyRange[1],
    doctorTel: '1234 5678',
    doctorPrice: priceRange[3],
    doctorRating: '4.7',
    doctorHospital: 'Wiloso Hospital',
    doctorNumberOfPatient: '888',
    doctorYearOfExperience: '4',
    doctorDescription:
        'is one of the best doctors in the Wiloso Hospital. He has saved more than 800 patients in the past 4 years. He has also received many awards from domestic and abroad as the best doctors. He is available on a private or schedule.',
    doctorPicture: 'img-women-03.png',
    doctorIsOpen: true
  ),
];

// class DoctorMenu {
//   String name;
//   String specialty;
//   String price;
//   String image;

//   DoctorMenu({this.name = '', this.specialty = '', this.price = '', this.image = ''});
// }

// var doctorMenu = [
//   DoctorMenu(name: 'Consultation', image: 'img-consultation.svg'),
//   DoctorMenu(name: 'Dental', image: 'img-dental.svg'),
//   DoctorMenu(name: 'Heart', image: 'img-heart.svg'),
//   DoctorMenu(name: 'Hospitals', image: 'img-hospital.svg'),
//   DoctorMenu(name: 'Medicines', image: 'img-medicine.svg'),
//   DoctorMenu(name: 'Physician', image: 'img-physician.svg'),
//   DoctorMenu(name: 'Skin', image: 'img-skin.svg'),
//   DoctorMenu(name: 'Surgeon', image: 'img-surgeon.svg'),
// ];