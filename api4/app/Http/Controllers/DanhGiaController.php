<?php

namespace App\Http\Controllers;

use App\Models\DanhGia;
use Illuminate\Http\Request;
use App\Models\DonHang;
class DanhGiaController extends Controller
{
    // Hiển thị danh sách đánh giá
    public function index()
    {
        $danhGias = DanhGia::with('donHang', 'chiTietDonHang')->get();
        return response()->json($danhGias);
    }
    public function getDanhGiaBySanPham($id)
    {
        // Lấy danh sách đánh giá của sản phẩm theo id sản phẩm
        $danhGias = DanhGia::with('chiTietDonHang', 'chiTietDonHang.sanPham', 'donHang')
            ->whereHas('chiTietDonHang', function ($query) use ($id) {
                $query->where('SanPhamId', $id);
            })
            ->get();

        return response()->json($danhGias);
    }
    // Thêm mới đánh giá
    public function store(Request $request)
    {
        // Xác thực dữ liệu đầu vào
        $validatedData = $request->validate([
            'DonHangId' => 'required|exists:DonHang,DonHangId',
            'CTDHId' => 'required|exists:ChiTietDonHang,CTDHId',
            'NoiDung' => 'nullable|string|max:1000',
            'Sao' => 'required|integer|min:1|max:5',
        ]);

        // Tạo một đánh giá mới từ dữ liệu đã xác thực
        $danhGia = DanhGia::create($validatedData);

        // Trả về phản hồi JSON với thông báo và dữ liệu đánh giá
        return response()->json([
            'message' => 'Đánh giá được thêm thành công!',
            'danhGia' => $danhGia,
        ], 200); // Mã 200 thể hiện thành công
    }



    // Cập nhật đánh giá
    public function update(Request $request, $id)
    {
        $danhGia = DanhGia::find($id);

        if (!$danhGia) {
            return response()->json(['message' => 'Đánh giá không tồn tại!'], 404);
        }

        $validatedData = $request->validate([
            'NoiDung' => 'nullable|string|max:1000',
            'Sao' => 'required|integer|min:1|max:5',
        ]);

        $danhGia->update($validatedData);

        return response()->json([
            'message' => 'Đánh giá được cập nhật thành công!',
            'danhGia' => $danhGia,
        ]);
    }

    // Xóa đánh giá
    public function destroy($id)
    {
        $danhGia = DanhGia::find($id);

        if (!$danhGia) {
            return response()->json(['message' => 'Đánh giá không tồn tại!'], 404);
        }

        $danhGia->delete();

        return response()->json(['message' => 'Đánh giá đã được xóa thành công!']);
    }
    public function getDanhGiaByCTDH($ctdhId)
    {
        // Lấy danh sách đánh giá theo CTDHId và chọn các cột mong muốn
        $danhGias = DanhGia::with('chiTietDonHang', 'donHang')
            ->where('CTDHId', $ctdhId)  // Truy vấn theo CTDHId
            ->select('NoiDung', 'Sao', 'CTDHId', 'DonHangId')  // Chọn cột cần thiết
            ->get();
    
        // Kiểm tra nếu không có kết quả
        if ($danhGias->isEmpty()) {
            return response()->json(['message' => 'Không tìm thấy đánh giá cho CTDHId này.'], 404);
        }
    
        // Trả về các đánh giá
        return response()->json($danhGias, 200);
    }
    



}
