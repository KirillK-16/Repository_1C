#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ДобавитьЗапись(КонтрольнаяПроцедура, ТипЗадачи, ДатаИВремя) Экспорт
	МенеджерЗаписи = РегистрыСведений.ВремяПоследнегоОповещения.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КонтрольнаяПроцедура = КонтрольнаяПроцедура;
	МенеджерЗаписи.ТипЗадачи = ТипЗадачи;
	МенеджерЗаписи.Время = ДатаИВремя;
	МенеджерЗаписи.Записать();
КонецПроцедуры

#КонецЕсли