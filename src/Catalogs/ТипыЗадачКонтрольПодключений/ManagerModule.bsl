#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьОсновнойШаблонКонтрольПодключенийНевозможноПодключиться() Экспорт
	Возврат "[Дата=дд.ММ.гг ЧЧ:мм];Не могу подключиться к [Отправитель]; [ПодробноеПредставлениеОшибки]";
КонецФункции

Функция ПолучитьОсновнойШаблонКонтрольПодключенийТаймаут() Экспорт
	Возврат "[Дата=дд.ММ.гг ЧЧ:мм];Не удалось подключиться за указанное время [Таймаут] к [Отправитель];";
КонецФункции

Функция ПолучитьШаблонПервойРегистрацииКонтрольПодключенийНевозможноПодключиться() Экспорт
	Возврат "Первичная регистрация ошибки";
КонецФункции

Функция ПолучитьШаблонПервойРегистрацииКонтрольПодключенийТаймаут() Экспорт
	Возврат "Первичная регистрация ошибки";
КонецФункции

Функция ПолучитьШаблонПовторнойРегистрацииКонтрольПодключенийНевозможноПодключиться() Экспорт
	Возврат "Период ошибки: [ДатаНачала=дд.ММ.гг ЧЧ:мм] - [ДатаЗавершения=дд.ММ.гг ЧЧ:мм]";
КонецФункции

Функция ПолучитьШаблонПовторнойРегистрацииКонтрольПодключенийТаймаут() Экспорт
	Возврат "Период ошибки: [ДатаНачала=дд.ММ.гг ЧЧ:мм] - [ДатаЗавершения=дд.ММ.гг ЧЧ:мм]";
КонецФункции

#КонецЕсли
