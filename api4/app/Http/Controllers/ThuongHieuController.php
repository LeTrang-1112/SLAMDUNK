<?php

namespace App\Http\Controllers;

use App\Models\ThuongHieu;
use Illuminate\Http\Request;

class ThuongHieuController extends Controller
{
    // Lấy danh sách tất cả các thương hiệu
    public function index()
    {
        $thuongHieus = ThuongHieu::all();
        return response()->json($thuongHieus);
    }

    // Lấy thông tin chi tiết về một thương hiệu theo ID
    public function show($id)
    {
        $thuongHieu = ThuongHieu::find($id);

        if (!$thuongHieu) {
            return response()->json(['message' => 'Thương hiệu không tồn tại'], 404);
        }

        return response()->json($thuongHieu);
    }

    // Tạo mới một thương hiệu
    public function store(Request $request)
    {
        $request->validate([
            'TenThuongHieu' => 'required|string|max:255',
            'MoTa' => 'required|string',
            'QuocGia' => 'required|string|max:255',
            'NgayTao' => 'required|date',
        ]);

        $thuongHieu = ThuongHieu::create([
            'TenThuongHieu' => $request->TenThuongHieu,
            'MoTa' => $request->MoTa,
            'QuocGia' => $request->QuocGia,
            'NgayTao' => $request->NgayTao,
        ]);

        return response()->json($thuongHieu, 201);
    }

    // Cập nhật thông tin một thương hiệu
    public function update(Request $request, $id)
    {
        $thuongHieu = ThuongHieu::find($id);

        if (!$thuongHieu) {
            return response()->json(['message' => 'Thương hiệu không tồn tại'], 404);
        }

        $request->validate([
            'TenThuongHieu' => 'required|string|max:255',
            'MoTa' => 'required|string',
            'QuocGia' => 'required|string|max:255',
            'NgayTao' => 'required|date',
        ]);

        $thuongHieu->update([
            'TenThuongHieu' => $request->TenThuongHieu,
            'MoTa' => $request->MoTa,
            'QuocGia' => $request->QuocGia,
            'NgayTao' => $request->NgayTao,
        ]);

        return response()->json($thuongHieu);
    }

    // Xóa một thương hiệu theo ID
    public function destroy($id)
    {
        $thuongHieu = ThuongHieu::find($id);

        if (!$thuongHieu) {
            return response()->json(['message' => 'Thương hiệu không tồn tại'], 404);
        }

        $thuongHieu->delete();

        return response()->json(['message' => 'Thương hiệu đã được xóa']);
    }
}
