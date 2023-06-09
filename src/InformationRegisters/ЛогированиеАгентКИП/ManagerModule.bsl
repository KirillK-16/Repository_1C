#Область ПрограммныйИнтерфейс

Процедура ДобавитьДанные(АгентКИП, Данные, Направление) Экспорт
    
    ТекДата = ТекущаяУниверсальнаяДатаВМиллисекундах();
    
    НаборЗаписей = СоздатьНаборЗаписей();
    НаборЗаписей.Отбор.Дата.Установить(ТекДата);
    НаборЗаписей.Отбор.АгентКИП.Установить(АгентКИП);
    
    НовСтрока = НаборЗаписей.Добавить();
    НовСтрока.АгентКИП = АгентКИП;
    НовСтрока.Дата = ТекДата;
    НовСтрока.Направление = Направление;
    НовСтрока.Данные = Данные;
    НаборЗаписей.Записать(Ложь);
    
КонецПроцедуры

#КонецОбласти