<?php

namespace App\Http\Controllers;

use App\Models\MakananMinuman;
use Illuminate\Http\Request;
use Exception;

class MakananMinumanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function indexBykategori($kategori)
    {
        try{
            $makananMinuman = MakananMinuman::where('kategori', $kategori)->get();
            return response()->json([
                'status' => true,
                'message' => 'Data makanan dan minuman berhasil diambil',
                'data' => $makananMinuman
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data makanan dan minuman gagal diambil',
                'data' => $e->getMessage()
            ], 400);
        }
    }
    public function index()
    {
        try{
            $makananMinuman = MakananMinuman::all();
            return response()->json([
                'status' => true,
                'message' => 'Data makanan dan minuman berhasil diambil',
                'data' => $makananMinuman
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data makanan dan minuman gagal diambil',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try{
            $makananMinuman = MakananMinuman::create($request->all());
            return response()->json([
                'status' => true,
                'message' => 'Data makanan dan minuman berhasil ditambahkan',
                'data' => $makananMinuman
            ], 200);
        }catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data makanan dan minuman gagal ditambahkan',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try{
            $makananMinuman = MakananMinuman::find($id);
            return response()->json([
                'status' => true,
                'message' => 'Data makanan dan minuman berhasil diambil',
                'data' => $makananMinuman
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data makanan dan minuman gagal diambil',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try{
            $makananMinuman = MakananMinuman::find($id);
            $makananMinuman->update($request->all());
            return response()->json([
                'status' => true,
                'message' => 'Data makanan dan minuman berhasil diubah',
                'data' => $makananMinuman
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data makanan dan minuman gagal diubah',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try{
            $makananMinuman = MakananMinuman::find($id);
            $makananMinuman->delete();
            return response()->json([
                'status' => true,
                'message' => 'Data makanan dan minuman berhasil dihapus',
                'data' => $makananMinuman
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data makanan dan minuman gagal dihapus',
                'data' => $e->getMessage()
            ], 400);
        }
    }

    public function search(Request $request)
    {
        $query = $request->input('query');
        $category = $request->input('category', null);

        $items = MakananMinuman::query()
            ->where('nama_item', 'LIKE', "%{$query}%")
            ->when($category, function ($query, $category) {
                return $query->where('kategori', $category);
            })
            ->get();

        return response()->json($items);
    }
}
