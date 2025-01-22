<?php

namespace App\Http\Controllers;
use App\Models\ChiTietDonHang;
use App\Models\DonHang;
use Illuminate\Http\Request;

class AminController extends Controller
{   
    //Tính số lượng sản phẩm đã bán
    public function totalSold(Request $request)
    {
        try {


            $soldQuantities = ChiTietDonHang::select('SanPhamId', \DB::raw('SUM(SoLuong) as total_sold'))
                ->groupBy('SanPhamId')
                ->orderByDesc('total_sold') 
                ->get();

            if ($soldQuantities->isEmpty()) {
                return response()->json([
                    'message' => 'Không có sản phẩm nào được bán.',
                    'data' => [],
                ], 404);
            }
            return response()->json([
                'message' => 'Tổng số lượng sản phẩm đã bán.',
                'data' => $soldQuantities,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Có lỗi xảy ra: ' . $e->getMessage(),
            ], 500);
        }
    }

    // Hiển thị danh sách đơn hàng
    public function index()
    {
        $donHangs = DonHang::with('nguoiDung')->orderBy('NgayDatHang', 'desc')->get();

        return response()->json([
            'message' => 'Danh sách đơn hàng',
            'data' => $donHangs,
        ]);
    }
// Hiển thị danh sách đơn hàng theo trạng thái
public function getByStatus($status)
{
    $donHangs = DonHang::with('nguoiDung')
                        ->where('TrangThai', $status)
                        ->orderBy('NgayDatHang', 'desc')
                        ->get();

    if ($donHangs->isEmpty()) {
        return response()->json([
            'message' => 'Không có đơn hàng trong trạng thái ' . $status,
            'data' => [],
        ], 404);
    }

    return response()->json([
        'message' => 'Danh sách đơn hàng trạng thái ' . $status,
        'data' => $donHangs,
    ]);
}

    // Hiển thị chi tiết đơn hàng
    public function show($id)
    {
        $donHang = DonHang::with('nguoiDung', 'chiTietDonHangs')->find($id);

        if (!$donHang) {
            return response()->json([
                'message' => 'Đơn hàng không tồn tại.',
            ], 404);
        }

        return response()->json([
            'message' => 'Chi tiết đơn hàng',
            'data' => $donHang,
        ]);
    }

    // Cập nhật trạng thái đơn hàng
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'TrangThai' => 'required|in:Chờ xác nhận,Đang giao,Đã giao,Đã hủy',
        ]);

        $donHang = DonHang::find($id);

        if (!$donHang) {
            return response()->json([
                'message' => 'Đơn hàng không tồn tại.',
            ], 404);
        }
        $donHang->TrangThai = $request->input('TrangThai');
        $donHang->save();
        return response()->json([
            'message' => 'Trạng thái đơn hàng đã được cập nhật.',
            'data' => $donHang,
        ]);
    }
}
