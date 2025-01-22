<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SanPham extends Model
{
    use HasFactory;
    protected $table = 'SanPham';
    protected $primaryKey = 'SanPhamId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'SanPhamId',
        'TenSanPham',
        'MoTa',
        'Gia',
        'KichThuoc',
        'ChatLieu',
        'ThuongHieuId',
        'SoLuongTon',
        'NgayTao',
    ];
    public function hinhAnhSanPhams()
    {
        return $this->hasMany(HinhAnhSanPham::class, 'SanPhamId');
    }

    public function chiTietGioHangs()
    {
        return $this->hasMany(ChiTietGioHang::class, 'SanPhamId');
    }

    public function chiTietDonHangs()
    {
        return $this->hasMany(ChiTietDonHang::class, 'SanPhamId');
    }

    public function khuyenMais()
    {
        return $this->belongsToMany(KhuyenMai::class, 'SanPhamKhuyenMai', 'SanPhamId', 'KhuyenMaiId');
    }
    public function thuongHieu()
{
    return $this->belongsTo(ThuongHieu::class, 'ThuongHieuId', 'ThuongHieuId');
}

}
