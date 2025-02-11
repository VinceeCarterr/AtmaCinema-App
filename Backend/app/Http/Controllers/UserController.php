<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Laravel\Sanctum\PersonalAccessToken;
use Exception;

class UserController extends Controller
{
    public function registerEmail(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email|unique:user,email', // Validasi email
            ]);

            // Cek jika email sudah terdaftar
            return response()->json([
                'status' => true,
                'message' => 'Email valid',
                'email' => $request->email,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Email sudah terdaftar atau tidak valid',
                'error' => $e->getMessage(),
            ], 400);
        }
    }

    // Endpoint untuk register data pengguna (registrasi lengkap)
    public function registerData(Request $request)
    {
        try {
            $request->validate([
                'first_name' => 'required|string',
                'last_name' => 'required|string',
                'email' => 'required|email',
                'password' => 'required|min:6',
                'no_telp' => 'required|string',
                'gender' => 'required|string',
                'tanggal_lahir' => 'required|date',
            ]);

            $profile_picture = 'images/blank-profile-picture.jpg';

            Log::info('User Data:', [
                'first_name' => $request->first_name,
                'last_name' => $request->last_name,
                'email' => $request->email,
                'no_telp' => $request->no_telp,
                'gender' => $request->gender,
                'tanggal_lahir' => $request->tanggal_lahir,
                'profile_picture' => $profile_picture,
            ]);


            // Hash password
            $user = User::create([
                'first_name' => $request->first_name,
                'last_name' => $request->last_name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'no_telp' => $request->no_telp,
                'gender' => $request->gender,
                'tanggal_lahir' => $request->tanggal_lahir,
                'profile_picture' => $profile_picture,
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Registrasi berhasil',
                'data' => $user,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Registrasi gagal',
                'error' => $e->getMessage(),
            ], 400);
        }
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                "status" => false,
                "message" => "Login Failed",
                "data" => "Invalid Credentials"
            ], 400);
        }

        // Membuat token
        $token = $user->createToken('Personal Access Token')->plainTextToken;

        return response()->json([
            "status" => true,
            "message" => "Login Success",
            "data" => [
                'token' => $token,
                'user' => $user,
            ]
        ], 200);
    }


    public function logout(Request $request)
    {
        try {
            if (Auth::check()) {
                $request->user()->currentAccessToken()->delete();

                return response()->json([
                    "status" => true,
                    "message" => "Logout Success",
                    "data" => null
                ], 200);
            } else {
                return response()->json(['message' => 'Unauthorized'], 401);
            }
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Logout Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function getProfile(Request $request)
    {
        // Mendapatkan pengguna yang sedang terautentikasi
        $user = $request->user();

        if ($user) {
            Log::info('User Profile: ' . $user->id);
        } else {
            Log::warning('Unauthorized access attempt');
        }

        // Jika tidak ada pengguna yang terautentikasi, kembalikan response error
        if (!$user) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized, please login.',
            ], 401);
        }

        // Mengembalikan data profil pengguna
        return response()->json([
            'status' => true,
            'data' => $user,
        ], 200);
    }


    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $user = User::all();

            return response()->json([
                "status" => true,
                "message" => "Get All User Success",
                "data" => $user
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Get All User Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $user = User::find($id);

            return response()->json([
                "status" => true,
                "message" => "Get User Success",
                "data" => $user
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Get User Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function updateProfile(Request $request)
    {
        $user = Auth::user(); // Get the authenticated user
        // Validate incoming data
        $validated = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'no_telp' => 'required|string|max:15',
            'gender' => 'nullable|string|max:6',
            'tanggal_lahir' => 'required|date',
            'profile_picture' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048', // Add image validation
        ]);

        // Update the user fields
        $user->first_name = $validated['first_name'];
        $user->last_name = $validated['last_name'];
        $user->no_telp = $validated['no_telp'];
        $user->gender = $validated['gender'];
        $user->tanggal_lahir = $validated['tanggal_lahir'];

        // Handle profile picture upload if exists
        if ($request->hasFile('profile_picture')) {
            $image = $request->file('profile_picture');
            $imagePath = $image->store('profile_pictures', 'public'); // Store the image in 'profile_pictures' folder

            // Save the image path in the database
            $user->profile_picture = $imagePath;
        }

        // Save the updated user
        /** @var \App\Models\User $user **/
        $user->save();

        // Return a response
        return response()->json([
            'message' => 'Profile updated successfully.',
            'user' => $user
        ], 200);
    }


    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => "Update User Failed",
                    "data" => "User Not Found"
                ], 400);
            }

            $request->validate([
                'first_name' => 'required',
                'last_name' => 'required',
                'no_telp' => 'required',
                'gender' => 'required',
                'tanggal_lahir' => 'required',
                'profile_picture'
            ]);

            $user->update([
                'first_name' => $request->first_name,
                'last_name' => $request->last_name,
                'no_telp' => $request->no_telp,
                'gender' => $request->gender,
                'tanggal_lahir' => $request->tanggal_lahir,
                'profile_picture' => $request->profile_picture
            ]);

            return response()->json([
                "status" => true,
                "message" => "Update User Success",
                "data" => $user
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Update User Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $user = User::find($id);
            $user->delete();
            return response()->json([
                "status" => true,
                "message" => "Delete User Success",
                "data" => $user
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Delete User Failed",
                "data" => $e->getMessage()
            ], 400);
        }
    }
}
