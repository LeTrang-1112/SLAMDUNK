<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SanPhamKhuyenMai extends Model
{
    use HasFactory;
    protected $table = 'sanphamkhuyenmai';
    protected $primaryKey = 'SanPhamKMId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'SanPhamKMId',
        'SanPhamId',
        'KhuyenMaiId',
    ];
    public function sanPham()
    {
        return $this->belongsTo(SanPham::class, 'SanPhamId');
    }

    public function khuyenMai()
    {
        return $this->belongsTo(KhuyenMai::class, 'KhuyenMaiId');
    }
}
