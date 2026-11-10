# Android Keystore & Signing Setup Instructions

1. **Generate Keystore File**:
   Run the following command in your terminal:
   ```bash
   keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Configure key.properties**:
   Copy `android/key.properties.example` to `android/key.properties`:
   ```properties
   storePassword=<your_store_password>
   keyPassword=<your_key_password>
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. **Security**:
   `android/key.properties` and `android/upload-keystore.jks` are automatically ignored in `.gitignore`. **NEVER** commit secret keys or passwords to version control.
