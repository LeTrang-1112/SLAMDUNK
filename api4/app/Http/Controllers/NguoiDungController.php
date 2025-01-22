<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\NguoiDung;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\GioHang;
class NguoiDungController extends Controller
{
    // Hiển thị danh sách người dùng (bao gồm kiểm tra quyền quản trị viên)
    public function index(Request $request)
    {
        $isAdmin = $request->input('IsAddmin');

        if (!$isAdmin) {
            return response()->json(['message' => 'Bạn không có quyền truy cập danh sách người dùng'], 403);
        }

        $nguoiDungs = NguoiDung::all();
        return response()->json($nguoiDungs, 200);
    }

    // Đăng ký người dùng mới
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'TenNguoiDung' => 'required|string|max:100',
            'Email' => 'required|email|unique:nguoidung,Email',
            'MatKhau' => 'required|string|min:6',
            'SoDienThoai' => 'nullable|string|max:15',
            'DiaChi' => 'nullable|string|max:255',
            'IsAdmin' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $nguoiDung = new NguoiDung();
        $nguoiDung->TenNguoiDung = $request->TenNguoiDung;
        $nguoiDung->Email = $request->Email;
        $nguoiDung->MatKhau = Hash::make($request->MatKhau);
        $nguoiDung->SoDienThoai = $request->SoDienThoai;
        $nguoiDung->DiaChi = $request->DiaChi;
        $nguoiDung->IsAdmin = $request->IsAdmin ?? 0; 
        $nguoiDung->save();

        return response()->json(['message' => 'Đăng ký thành công', 'nguoiDung' => $nguoiDung], 201);
    }

    // Đăng nhập người dùng
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Email' => 'required|email',
            'MatKhau' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $nguoiDung = NguoiDung::where('Email', $request->Email)->first();

        if (!$nguoiDung || !Hash::check($request->MatKhau, $nguoiDung->MatKhau)) {
            return response()->json(['message' => 'Email hoặc mật khẩu không đúng'], 401);
        }

        return response()->json([
            'message' => 'Đăng nhập thành công',
            'nguoiDung' => $nguoiDung,
            'IsAdmin' => $nguoiDung->IsAdmin, 
        ], 200);
    }

    // Thay đổi thông tin người dùng
    public function update(Request $request, $id)
    {
        $nguoiDung = NguoiDung::find($id);

        if (!$nguoiDung) {
            return response()->json(['message' => 'Người dùng không tồn tại'], 404);
        }

        $validator = Validator::make($request->all(), [
            'TenNguoiDung' => 'nullable|string|max:100',
            'SoDienThoai' => 'nullable|string|max:15',
            'DiaChi' => 'nullable|string|max:255',
            'MatKhau' => 'nullable|string|min:6',
            'IsAdmin' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        if ($request->has('TenNguoiDung')) {
            $nguoiDung->TenNguoiDung = $request->TenNguoiDung;
        }
        if ($request->has('SoDienThoai')) {
            $nguoiDung->SoDienThoai = $request->SoDienThoai;
        }
        if ($request->has('DiaChi')) {
            $nguoiDung->DiaChi = $request->DiaChi;
        }
        if ($request->has('MatKhau')) {
            $nguoiDung->MatKhau = Hash::make($request->MatKhau);
        }
        if ($request->has('IsAdmin')) {
            $nguoiDung->IsAdmin = $request->IsAdmin;
        }

        $nguoiDung->save();

        return response()->json(['message' => 'Cập nhật thông tin thành công', 'nguoiDung' => $nguoiDung], 200);
    }

    // Hiển thị thông tin chi tiết người dùng
    public function show($id)
    {
        $nguoiDung = NguoiDung::find($id);

        if (!$nguoiDung) {
            return response()->json(['message' => 'Người dùng không tồn tại'], 404);
        }

        return response()->json($nguoiDung, 200);
    }
    public function showAdmin($id)
    {
        $nguoiDung = NguoiDung::find($id);

        if (!$nguoiDung) {
            return response()->json(['message' => 'Người dùng không tồn tại'], 404);
        }
        $isAdmin = $nguoiDung->IsAdmin;
        return response()->json(['isAdmin' => $isAdmin], 200);
    }
    // Hàm đổi mật khẩu
    public function changePassword(Request $request)
{
    // Xác thực các dữ liệu được truyền vào
    $validatedData = $request->validate([
        'nguoidungid' => 'required|integer|exists:users,id', // Kiểm tra ID người dùng hợp lệ
        'current_password' => 'required|string|min:6', // Kiểm tra mật khẩu cũ có ít nhất 6 ký tự
        'new_password' => 'required|string|min:6|confirmed', // Mật khẩu mới phải xác nhận đúng
    ]);

    // Lấy thông tin người dùng theo nguoidungid
    $user = User::find($request->nguoidungid);

    // Kiểm tra xem người dùng có tồn tại không
    if (!$user) {
        return response()->json([
            'message' => 'Người dùng không tồn tại.',
        ], 404);
    }

    // Kiểm tra mật khẩu cũ
    if (!Hash::check($request->current_password, $user->MatKhau)) {
        return response()->json([
            'message' => 'Mật khẩu cũ không chính xác.',
        ], 400);
    }

    // Kiểm tra mật khẩu mới phải khác mật khẩu cũ
    if ($request->current_password === $request->new_password) {
        return response()->json([
            'message' => 'Mật khẩu mới không được trùng với mật khẩu cũ.',
        ], 400);
    }

    // Cập nhật mật khẩu mới
    $user->MatKhau = Hash::make($request->new_password); 
    $user->save();

    // Trả về thông báo thành công
    return response()->json([
        'message' => 'Mật khẩu đã được thay đổi thành công.',
    ], 200);
}
public function thaydoimatkhau(Request $request)
{
    // Xác thực dữ liệu yêu cầu
    $validator = Validator::make($request->all(), [
        'NguoiDungId' => 'required|integer|exists:nguoidung,nguoidungid',  // Đảm bảo kiểu là integer và tồn tại trong bảng users
        'matKhau' => 'required|string|min:6',  // Mật khẩu cũ, ít nhất 6 ký tự
        'matKhauMoi' => 'required|string|min:6|confirmed',  // Mật khẩu mới, ít nhất 6 ký tự và phải xác nhận đúng
    ]);
    
    if ($validator->fails()) {
        return response()->json(['errors' => $validator->errors()], 400);
    }

    // Tìm người dùng theo NguoiDungId (ID người dùng)
    $nguoiDung = NguoiDung::find($request->NguoiDungId);  

    if (!$nguoiDung) {
        return response()->json(['message' => 'Người dùng không tồn tại'], 404);
    }

    // Kiểm tra mật khẩu cũ có chính xác không
    if (!Hash::check($request->matKhau, $nguoiDung->MatKhau)) {
        return response()->json(['message' => 'Mật khẩu cũ không chính xác'], 400);
    }

    // Cập nhật mật khẩu mới
    $nguoiDung->MatKhau = Hash::make($request->matKhauMoi);  // Mã hóa mật khẩu mới
    $nguoiDung->save();

    return response()->json(['message' => 'Mật khẩu đã được thay đổi thành công'], 200);
}

    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Email' => 'required|email',
            'SoDienThoai' => 'required|string|max:15',
            'new_password' => 'required|string|min:6|confirmed',
        ]);
    
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }
    
        // Tìm người dùng theo Email và Số điện thoại
        $nguoiDung = NguoiDung::where('Email', $request->Email)
            ->where('SoDienThoai', $request->SoDienThoai)
            ->first();
    
        if (!$nguoiDung) {
            return response()->json(['message' => 'Email hoặc số điện thoại không khớp'], 404);
        }
    
        // Cập nhật mật khẩu mới
        $nguoiDung->MatKhau = Hash::make($request->new_password);
        $nguoiDung->save();
    
        return response()->json(['message' => 'Mật khẩu đã được đặt lại thành công'], 200);
    }
    public function createCartForUser(Request $request)
    {
        // Kiểm tra NguoiDungId
        $nguoiDungId = $request->NguoiDungId;

        // Kiểm tra xem người dùng có tồn tại hay không
        $nguoiDung = NguoiDung::find($nguoiDungId);
        if (!$nguoiDung) {
            return response()->json(['message' => 'Người dùng không tồn tại'], 404);
        }

        // Kiểm tra xem người dùng đã có giỏ hàng chưa
        $gioHang = GioHang::where('NguoiDungId', $nguoiDungId)->first();

        if ($gioHang) {
            // Nếu đã có giỏ hàng, trả về giỏ hàng hiện tại
            return response()->json([
                'message' => 'Giỏ hàng đã tồn tại',
                'gioHang' => $gioHang
            ], 200);
        } else {
            // Nếu chưa có giỏ hàng, tạo mới giỏ hàng cho người dùng
            $gioHang = new GioHang();
            $gioHang->NguoiDungId = $nguoiDungId;
            $gioHang->TongTien = 0; // Giá trị mặc định của tổng tiền là 0
            $gioHang->NgayTao = now(); // Ngày tạo giỏ hàng
            $gioHang->save();

            return response()->json([
                'message' => 'Giỏ hàng đã được tạo',
                'gioHang' => $gioHang
            ], 201);
        }
    }

}
