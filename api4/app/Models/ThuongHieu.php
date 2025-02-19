<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ThuongHieu extends Model
{
    use HasFactory;
    protected $table = 'thuonghieu';
    protected $primaryKey = 'ThuongHieuId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'ThuongHieuId',
        'TenThuongHieu',
        'MoTa',
        'QuocGia',
        'NgayTao',
    ];
    public function sanPhams()
    {
        return $this->hasMany(SanPham::class, 'ThuongHieuId');
    }


}
