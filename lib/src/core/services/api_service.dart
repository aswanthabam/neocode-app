import 'package:digital_vault/src/core/models/document_model.dart';
import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:digital_vault/src/core/models/user_model.dart';

class ApiService {
  // Simulates fetching user profile
  Future<User> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return User(
      id: 'user123',
      fullName: 'John Doe',
      vaultId: 'john.doe@vault',
      mobileNumber: '+1234567890',
    );
  }

  // Simulates fetching documents
  Future<List<Document>> getDocuments() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
       Document(id: '1', name: 'Aadhaar Card', type: 'National ID', issuer: 'UIDAI', issueDate: DateTime(2020, 5, 20), trustLevel: TrustLevel.issuerVerified, fileUrl: ''),
       Document(id: '2', name: 'Driving License', type: 'Identity', issuer: 'Transport Dept.', issueDate: DateTime(2022, 1, 15), trustLevel: TrustLevel.issuerVerified, fileUrl: ''),
       Document(id: '3', name: 'SSC Marksheet', type: 'Education', issuer: 'State Board', issueDate: DateTime(2015, 6, 1), trustLevel: TrustLevel.userUploaded, fileUrl: ''),
    ];
  }

  // Simulates fetching document requests
  Future<List<DocumentRequest>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      DocumentRequest(
        id: 'req1',
        requesterName: 'ABC Bank',
        requesterId: 'abc@bank',
        requestDate: DateTime.now().subtract(const Duration(hours: 2)),
        requestedDocuments: [ /* Populate with mock documents if needed */ ],
      ),
    ];
  }

  // Simulates sending an OTP
  Future<bool> sendOtp(String mobileNumber) async {
    await Future.delayed(const Duration(seconds: 2));
    print('OTP sent to $mobileNumber');
    return true;
  }

  // Simulates verifying an OTP
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '123456'; // Mock OTP
  }
}
