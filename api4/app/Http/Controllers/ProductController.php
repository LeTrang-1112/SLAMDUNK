<?php

namespace App\Http\Controllers;

use App\Models\SanPham;
use App\Models\HinhAnhSanPham;
use App\Models\KhuyenMai;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function ThongTinSanPham()
    {
        $products = SanPham::with(['hinhAnhSanPhams', 'khuyenMais'])->get();

        $response = $products->map(function ($product) {
            $discount = $product->khuyenMais->sum('GiaTriGiam');
            
            $image = $product->hinhAnhSanPhams->first();
            $imageUrl = $image ? $image->DuongDan : null;

            return [
                'SanPhamId' => $product->SanPhamId,  
                'TenSanPham' => $product->TenSanPham, 
                'Gia' => $product->Gia,
                'HinhAnh' => $imageUrl, 
                'GiaTriGiam' => $discount > 0 ? $discount : null, 
                'NgayTao' =>$product->NgayTao
            ];
        });

        return response()->json($response);
    }

    public function ChiTietSanPham($id)
    {
        $product = SanPham::with(['thuongHieu', 'hinhAnhSanPhams'])->find($id);

        if (!$product) {
            return response()->json(['error' => 'Sản phẩm không tồn tại'], 404);
        }

        return response()->json([
            'SanPhamId' => $product->SanPhamId, 
            'MoTa' => $product->MoTa, 
            'KichThuoc' => $product->KichThuoc,
            'ChatLieu' => $product->ChatLieu,
            'SoLuongTon' => $product->SoLuongTon, 
            'TenThuongHieu' => $product->thuongHieu->TenThuongHieu,
            'HinhAnhs' => $product->hinhAnhSanPhams->map(function ($image) {
                return [
                    'id' => $image->HinhAnhId,
                    'path' => $image->DuongDan, 
                    'description' => $image->MoTa, 
                ];
            }),
        ]);
    }

}
