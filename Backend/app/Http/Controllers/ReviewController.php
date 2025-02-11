<?php

namespace App\Http\Controllers;

use App\Models\Film;
use App\Models\User;

use App\Models\Review;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Exception;
use Illuminate\Support\Facades\DB;

use Illuminate\Support\Facades\Log;

class ReviewController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($id)
    {
        try {
            // Mengambil data review berdasarkan id_film
            $reviews = Review::join('user', 'user.id_user', '=', 'review.id_user')
                ->select(
                    'review.id_film',
                    'review.created_at', // Pastikan kolom ini ada di tabel
                    DB::raw('CONCAT(user.first_name, " ", user.last_name) AS full_name'),
                    'review.rating_review',
                    'review.deskripsi_review'
                )
                ->where('review.id_film', $id)
                ->get();

            foreach ($reviews as &$review) {
                // Periksa apakah created_at tersedia
                if (!empty($review['created_at'])) {
                    $createdAt = Carbon::createFromFormat('Y-m-d H:i:s', $review['created_at'], 'Asia/Bangkok');
                    $now = Carbon::now('Asia/Bangkok');

                    $diffInMinutes = $createdAt->diffInMinutes($now);
                    $diffInHours = $createdAt->diffInHours($now);
                    $diffInDays = $createdAt->diffInDays($now);

                    if ($diffInMinutes < 60) {
                        $review['review_at'] = floor($diffInMinutes) . " minutes ago";
                    } elseif ($diffInHours < 24) {
                        $review['review_at'] = floor($diffInHours) . " hours ago";
                    } else {
                        $review['review_at'] = floor($diffInDays) . " days ago";
                    }
                } else {
                    $review['review_at'] = "Unknown time";
                }
            }

            // Menghitung statistik dengan satu query
            $stats = Review::where('id_film', $id)
                ->selectRaw('AVG(rating_review) as average_rating, COUNT(*) as total_reviews, COUNT(deskripsi_review) as total_descriptions')
                ->first();

            $data = [
                'average' => number_format($stats->average_rating, 1),
                'total_rating' => $stats->total_reviews,
                'total_descriptions' => $stats->total_descriptions,
                'reviews' => $reviews,
            ];

            return response()->json([
                'success' => true,
                'message' => 'Daftar data review',
                'data' => $data,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menampilkan data review',
                'data' => $e->getMessage(),
            ], 409);
        }
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $validateData = $request->validate([
                'id_film' => 'required',
                'id_user' => 'required',
                'rating_review' => 'required',
                'deskripsi_review' => 'required'
            ]);

            $filmId = $validateData['id_film'];
            $film = Film::find($filmId);
            if (!$film) {
                return response()->json([
                    'success' => false,
                    'message' => 'Film tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $userId = $validateData['id_user'];
            $user = User::find($userId);
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $review = Review::create($validateData);
            return response()->json([
                'success' => true,
                'message' => 'Review berhasil ditambahkan',
                'data' => $review
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan review',
                'data' => $e
            ], 409);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $review = Review::find($id);
            return response()->json([
                'success' => true,
                'message' => 'Detail data review',
                'data' => $review
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Review tidak ditemukan',
                'data' => ''
            ], 404);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try {
            $review = Review::find($id);

            if (!$review) {
                return response()->json([
                    'success' => false,
                    'message' => 'Review tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $validateData = $request->validate([
                'id_film' => 'required',
                'id_user' => 'required',
                'rating_review' => 'required',
                'deskripsi_review' => 'required'
            ]);

            $filmId = $validateData['id_film'];
            $film = Film::find($filmId);
            if (!$film) {
                return response()->json([
                    'success' => false,
                    'message' => 'Film tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $userId = $validateData['id_user'];
            $user = User::find($userId);
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan',
                    'data' => ''
                ], 404);
            }

            $review->update($validateData);
            return response()->json([
                'success' => true,
                'message' => 'Review berhasil diubah',
                'data' => $review
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengubah review',
                'data' => $e
            ], 409);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $review = Review::find($id);
            $review->delete();
            return response()->json([
                'success' => true,
                'message' => 'Review berhasil dihapus',
                'data' => $review
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus review',
                'data' => $e
            ], 409);
        }
    }
}
